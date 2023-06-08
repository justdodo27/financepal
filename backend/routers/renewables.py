from typing import Annotated, Union, Optional
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import uuid
import os

from fastapi import APIRouter, Depends, HTTPException, Path, UploadFile, Request
from sqlalchemy.ext.asyncio import AsyncSession
import aiofiles

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])

@router.post("/renewables/", tags=["renewables"], response_model=schemas.Renewable)
async def create_renewable(renewable: schemas.RenewableBase,
                           current_user: schemas.User = Depends(dependencies.get_current_user),
                           db: AsyncSession = Depends(get_db)):
    renewable.user_id = current_user.id

    if not renewable.name or len(renewable.name) == 0:
        raise HTTPException(status_code=409, detail="renewable name is required")
    if not renewable.type:
        raise HTTPException(status_code=409, detail="renewable type is required")
    if not renewable.cost:
        raise HTTPException(status_code=409, detail="renewable cost is required")
    if not renewable.payment_date:
        raise HTTPException(status_code=409, detail="Renewable payment_date is required")
    if renewable.type.value not in ('BILL', 'INVOICE', 'SUBSCRIPTION'):
        raise HTTPException(status_code=409, detail="renewable type allowed values are BILL, INVOICE or SUBSCRIPTION")
    if renewable.category_id and not await crud.get_category(db=db, category_id=renewable.category_id):
        raise HTTPException(status_code=409, detail=f"Category ID {renewable.category_id} doesn't exist")    
    if renewable.period.value not in ('YEARLY', 'MONTHLY', 'WEEKLY', 'DAILY'):
        raise HTTPException(status_code=409, detail="renewable period allowed values are YEARLY, MONTHLY, WEEKLY, DAILY")
    if renewable.group_id:
        if not (group := await crud.get_group(db, group_id=renewable.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    new_renewable = await crud.create_renewable(db, renewable)

    return new_renewable

@router.put("/renewables/{renewable_id}/", tags=["renewables"], response_model=schemas.Renewable)
async def update_renewable(renewable_update: schemas.RenewableBase,
                           current_user: schemas.User = Depends(dependencies.get_current_user),
                           renewable_id: int = Path(title="The ID of the renewable to get"),
                           db: AsyncSession = Depends(get_db)):
    if not (renewable := await crud.get_renewable(db, renewable_id)):
        raise HTTPException(status_code=404, detail=f"Renewable doesn't exist")
    
    if renewable.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    if renewable.group_id:
        if not (group := await crud.get_group(db, group_id=renewable.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
    
    renewable_update.user_id = current_user.id

    if not (updated := await crud.update_renewable(db, renewable, renewable_update)):
        raise HTTPException(status_code=500, detail="Error while updating payment")
    return updated

@router.delete("/renewables/{renewable_id}/", tags=["renewables"])
async def delete_renewable(current_user: schemas.User = Depends(dependencies.get_current_user),
                           renewable_id: int = Path(title="The ID of the renewable to get"),
                           db: AsyncSession = Depends(get_db)):
    if (renewable := await crud.get_renewable(db, renewable_id)):
        if renewable.user_id != current_user.id:
            raise HTTPException(status_code=403, detail=f"Forbidden")
        if renewable.group_id:
            if not (group := await crud.get_group(db, group_id=renewable.group_id)):
                raise HTTPException(status_code=404, detail="Group not found")
            if not group.is_member(current_user):
                raise HTTPException(status_code=403, detail="You don't belong to this group")
        if await crud.delete_renewable(db, renewable):
            return True
        raise HTTPException(status_code=500, detail="Error while deleting renewable")
    raise HTTPException(status_code=404, detail="Renewable with given ID don't exist")

@router.post("/renewables/payment/{renewable_id}/", tags=["renewables"], response_model=schemas.Payment)
async def create_payment(payment_data: schemas.RenewablePayment,
                         current_user: schemas.User = Depends(dependencies.get_current_user),
                         renewable_id: int = Path(title="The ID of the renewable to get"),
                         db: AsyncSession = Depends(get_db)):
    if (renewable := await crud.get_renewable(db, renewable_id)):
        if renewable.user_id != current_user.id:
            raise HTTPException(status_code=403, detail=f"Forbidden")
        if renewable.group_id:
            if not (group := await crud.get_group(db, group_id=renewable.group_id)):
                raise HTTPException(status_code=404, detail="Group not found")
            if not group.is_member(current_user):
                raise HTTPException(status_code=403, detail="You don't belong to this group")
        payment = schemas.PaymentBase(
            name=f"{renewable.name} - payment {payment_data.payment_date}",
            type=renewable.type,
            category_id=renewable.category_id,
            user_id=renewable.user_id,
            cost=payment_data.cost if payment_data.cost else renewable.cost,
            payment_date=payment_data.payment_date,
            payment_proof_id=None,
            renewable_id=renewable.id
        )
        if (new_payment := await crud.create_payment(db, payment)):
            return new_payment
        raise HTTPException(status_code=500, detail="Error while creating payment")
    raise HTTPException(status_code=404, detail="Renewable with given ID don't exist")


@router.get("/renewables/", tags=["renewables"], response_model=list[schemas.Renewable])
async def get_user_awaiting_renewables(request: Request,
                                       group_id: Optional[int] = None,
                                       current_user: schemas.User = Depends(dependencies.get_current_user), 
                                       db: AsyncSession = Depends(get_db)):
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        renewables = await crud.get_group_renewables(db, group_id=group_id)
    else:
        renewables = await crud.get_user_renewables(db, current_user.id)

    results = []
    for renewable in renewables:
        if payment := await crud.get_last_payment_for_renewable(db, renewable.id):
            if renewable.period.value == 'YEARLY':
                next_payment = payment.payment_date + relativedelta(years=1)
            elif renewable.period.value == 'MONTHLY':
                next_payment = payment.payment_date + relativedelta(months=1)
            elif renewable.period.value == 'WEEKLY':
                next_payment = payment.payment_date + relativedelta(weeks=1)
        else: 
            next_payment = datetime.now()
        results.append(
            schemas.Renewable(
                id=renewable.id,
                name=renewable.name,
                type=renewable.type,
                category_id=renewable.category_id,
                user_id=current_user.id,
                cost=renewable.cost,
                payment_date=next_payment,
                category=schemas.Category(
                    id=renewable.category.id,
                    category=renewable.category.category,
                    user_id=renewable.category.user_id
                ) if renewable.category_id else None,
                period=renewable.period,
                last_payment=schemas.RenewablePayment(
                    cost=payment.cost,
                    payment_date=payment.payment_date
                ) if payment else None
            )
        )

    return results