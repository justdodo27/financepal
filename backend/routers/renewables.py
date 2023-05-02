from typing import Annotated, Union, Optional
from datetime import datetime, timedelta
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

    new_renewable = await crud.create_renewable(db, renewable)

    return new_renewable

@router.put("/renewables/{renewable_id}", tags=["renewables"], response_model=schemas.Renewable)
async def update_renewable(renewable_update: schemas.RenewableBase,
                           current_user: schemas.User = Depends(dependencies.get_current_user),
                           renewable_id: int = Path(title="The ID of the renewable to get"),
                           db: AsyncSession = Depends(get_db)):
    if not (renewable := await crud.get_renewable(db, renewable_id)):
        raise HTTPException(status_code=404, detail=f"Renewable doesn't exist")
    
    if renewable.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    renewable_update.user_id = current_user.id

    if not (updated := await crud.update_renewable(db, renewable, renewable_update)):
        raise HTTPException(status_code=500, detail="Error while updating payment")
    return updated

@router.delete("/renewables/{renewable_id}", tags=["renewables"])
async def delete_renewable(current_user: schemas.User = Depends(dependencies.get_current_user),
                           renewable_id: int = Path(title="The ID of the renewable to get"),
                           db: AsyncSession = Depends(get_db)):
    if (renewable := await crud.get_renewable(db, renewable_id)):
        if renewable.user_id != current_user.id: # also check for gorup
            raise HTTPException(status_code=403, detail=f"Forbidden")
        if await crud.delete_renewable(db, renewable):
            return True
        raise HTTPException(status_code=500, detail="Error while deleting renewable")
    raise HTTPException(status_code=404, detail="Renewable with given ID don't exist")

@router.post("/renewables/payment/{renewable_id}", tags=["renewables", "payments"], response_model=schemas.Payment)
async def create_payment(payment_data: schemas.RenewablePayment,
                         current_user: schemas.User = Depends(dependencies.get_current_user),
                         renewable_id: int = Path(title="The ID of the renewable to get"),
                         db: AsyncSession = Depends(get_db)):
    if (renewable := await crud.get_renewable(db, renewable_id)):
        if renewable.user_id != current_user.id: # also check for gorup
            raise HTTPException(status_code=403, detail=f"Forbidden")
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


@router.get("/renewables/awaiting/", tags=["renewables"], response_model=list[schemas.Renewable])
async def get_user_awaiting_renewables(request: Request,
                                       start_date: Optional[datetime] = None,
                                       end_date: Optional[datetime] = None, 
                                       group_id: Optional[int] = None,
                                       current_user: schemas.User = Depends(dependencies.get_current_user), 
                                       db: AsyncSession = Depends(get_db)):
    renewables = await crud.get_user_renewables(db, current_user.id)

    results = []
    now = datetime.utcnow()
    begin_date = None
    for renewable in renewables:
        if renewable.period.value == 'YEARLY':
            due_date = renewable.payment_date.replace(
                year=end_date.year if end_date else now.year
            )
            begin_date = datetime.utcnow().replace(
                month=1, 
                day=1
            )
        if renewable.period.value == 'MONTHLY':
            due_date = renewable.payment_date.replace(
                year=end_date.year if end_date else now.year, 
                month=end_date.month if end_date else now.month
            )
            begin_date = datetime.utcnow().replace(
                month=start_date.month if start_date else now.month, 
                day=start_date.day if start_date else 1
            )
        if renewable.period.value == 'WEEKLY':
            due_date = renewable.payment_date.replace(
                year=end_date.year if end_date else (now + timedelta(days=renewable.payment_date.weekday-now.weekday)).year, 
                month=end_date.month if end_date else (now + timedelta(days=renewable.payment_date.weekday-now.weekday)).month,
                day=end_date.day if end_date else (now + timedelta(days=renewable.payment_date.weekday-now.weekday)).day
            )
            begin_date = datetime.utcnow().replace(
                year=start_date.year if start_date else (now - timedelta(days=now.weekday)).year, 
                month=start_date.month if start_date else (now - timedelta(days=now.weekday)).month,
                day=start_date.day if start_date else (now - timedelta(days=now.weekday)).day
            )
        if renewable.period == 'DAILY':
            continue
        payments = await crud.get_user_awaiting_renewables(db, begin_date, due_date, renewable.id)
        print(payments, renewable.name, due_date, begin_date)
        if not payments:
            results.append(
                schemas.Renewable(
                    id=renewable.id,
                    name=renewable.name,
                    type=renewable.type,
                    category_id=renewable.category_id,
                    cost=renewable.cost,
                    payment_date=due_date,
                    category=schemas.Category(
                        id=renewable.category.id,
                        category=renewable.category.category,
                        user_id=renewable.category.user_id
                    ) if renewable.category_id else None,
                    period=renewable.period
                )
            )

    return results