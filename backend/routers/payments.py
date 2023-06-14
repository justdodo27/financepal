from typing import Union, Optional
from datetime import datetime
import uuid
import os

from fastapi import APIRouter, Depends, HTTPException, Path, UploadFile, Request
from sqlalchemy.ext.asyncio import AsyncSession
import aiofiles

from backend import crud, schemas, dependencies
from backend.database import get_db
from backend.notifications import check_notifications, test_notification

router = APIRouter(dependencies=[])


@router.post("/payments/", tags=["payments"], response_model=schemas.Payment)
async def create_payment(payment: schemas.PaymentBase,
                         current_user: schemas.User = Depends(dependencies.get_current_user),
                         db: AsyncSession = Depends(get_db)):
    payment.user_id = current_user.id

    if not payment.name or len(payment.name) == 0:
        raise HTTPException(status_code=409, detail="Payment name is required")
    if not payment.type:
        raise HTTPException(status_code=409, detail="Payment type is required")
    if not payment.cost:
        raise HTTPException(status_code=409, detail="Payment cost is required")
    if not payment.payment_date:
        raise HTTPException(status_code=409, detail="Payment payment_date is required")
    if payment.type.value not in ('BILL', 'INVOICE', 'SUBSCRIPTION'):
        raise HTTPException(status_code=409, detail="Payment type must allowed values are BILL, INVOICE or SUBSCRIPTION")
    if payment.category_id and not await crud.get_category(db=db, category_id=payment.category_id):
        raise HTTPException(status_code=409, detail=f"Category ID {payment.category_id} doesn't exist")
    if payment.group_id:
        if not (group := await crud.get_group(db, group_id=payment.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    new_payment = await crud.create_payment(db=db, payment=payment)
    
    await check_notifications(db=db, user_id=payment.user_id, group_id=payment.group_id)
    
    return new_payment


@router.get("/payments/", tags=["payments"], response_model=list[schemas.PaymentWithProof])
async def get_payments(request: Request,
                       start_date: Optional[datetime] = None,
                       end_date: Optional[datetime] = None, 
                       group_id: Optional[int] = None,
                       current_user: schemas.User = Depends(dependencies.get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        return [
            schemas.PaymentWithProof(
                id=payment.id,
                name=payment.name,
                type=payment.type,
                category_id=payment.category_id,
                cost=payment.cost,
                payment_date=payment.payment_date,
                renewable_id=payment.renewable_id,
                category=schemas.Category(
                    id=payment.category.id,
                    category=payment.category.category,
                    user_id=payment.category.user_id
                ) if payment.category else None,
                payment_proof_id=payment.payment_proof_id,
                payment_proof=schemas.PaymentProof(
                    filename=payment.payment_proof.filename,
                    url=f'{request.base_url}static/{payment.payment_proof.filename}',
                    user_id=payment.payment_proof.user_id,
                    id=payment.payment_proof.id,
                    name=payment.payment_proof.name
                ) if payment.payment_proof else None
            ) for payment in await crud.get_group_payments(db=db, group_id=group_id, start_date=start_date, end_date=end_date)
        ]

    return [
        schemas.PaymentWithProof(
            id=payment.id,
            name=payment.name,
            type=payment.type,
            category_id=payment.category_id,
            cost=payment.cost,
            payment_date=payment.payment_date,
            renewable_id=payment.renewable_id,
            category=schemas.Category(
                id=payment.category.id,
                category=payment.category.category,
                user_id=payment.category.user_id
            ) if payment.category else None,
            payment_proof_id=payment.payment_proof_id,
            payment_proof=schemas.PaymentProof(
                filename=payment.payment_proof.filename,
                url=f'{request.base_url}static/{payment.payment_proof.filename}',
                user_id=payment.payment_proof.user_id,
                id=payment.payment_proof.id,
                name=payment.payment_proof.name
            ) if payment.payment_proof else None
        ) for payment in await crud.get_user_payments(db=db, user_id=current_user.id, start_date=start_date, end_date=end_date)
    ]


@router.put("/payments/{payment_id}/", tags=["payments"], response_model=schemas.Payment)
async def update_payments(payment_update: schemas.PaymentBase,
                          current_user: schemas.User = Depends(dependencies.get_current_user), 
                          payment_id: int = Path(title="The ID of the payment to get"),
                          db: AsyncSession = Depends(get_db)):
    if not (payment := await crud.get_payment(db=db, payment_id=payment_id)):
        raise HTTPException(status_code=404, detail=f"Payment doesn't exist")

    if payment.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    if payment.group_id:
        if not (group := await crud.get_group(db, group_id=payment.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    payment_update.user_id = current_user.id

    if payment_update.payment_proof_id:
        if not (proof := await crud.get_payment_proof(db, payment_proof_id=payment_update.payment_proof_id)):
            raise HTTPException(status_code=404, detail="Payment proof not found")
        if proof.group_id:
            proof_group = await crud.get_group(db, proof.group_id)
            if not proof_group.is_member(current_user):
                raise HTTPException(status_code=403, detail="This payment proof don't belongs to your group")    
        elif proof.user_id != current_user.id:
            print(proof.user_id, current_user.id)
            raise HTTPException(status_code=403, detail="This payment proof don't belongs to you")

    if not (updated  := await crud.update_payment(db=db, payment=payment, update_data=payment_update)):
        raise HTTPException(status_code=500, detail="Error while updating payment")

    
    await check_notifications(db, user_id=payment_update.user_id, group_id=updated.group_id)
    
    return updated


@router.delete("/payments/{payment_id}/", tags=["payments"])
async def delete_payment(current_user: schemas.User = Depends(dependencies.get_current_user), 
                         payment_id: int = Path(title="The ID of the payment to get"),
                         db: AsyncSession = Depends(get_db)):
    if (payment := await crud.get_payment(db, payment_id)):
        if payment.user_id != current_user.id:
            raise HTTPException(status_code=403, detail=f"Forbidden")
        if payment.group_id:
            if not (group := await crud.get_group(db, group_id=payment.group_id)):
                raise HTTPException(status_code=404, detail="Group not found")
            if not group.is_member(current_user):
                raise HTTPException(status_code=403, detail="You don't belong to this group")
        if await crud.delete_payment(db, payment):
            return True
        raise HTTPException(status_code=500, detail="Error while deleting payment")
    raise HTTPException(status_code=404, detail="Payment with given ID don't exist")


@router.post("/payment_proofs/", tags=["payment_proofs"])
async def upload_payment_proof(request: Request,
                               payment_proof_name: str,
                               group_id: Union[int, None] = None,
                               current_user: schemas.User = Depends(dependencies.get_current_user),
                               file: Union[UploadFile, None] = None,
                               db: AsyncSession = Depends(get_db)):
    if not file:
        return {"message": "No upload file sent"}
    
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    generated_filename = f'{current_user.username}-{uuid.uuid4()}-{file.filename}'
    async with aiofiles.open(f'/app/backend/static/{generated_filename}', 'wb') as out_file:
        while content := await file.read(1024):  # async read chunk
            await out_file.write(content)  # async write chunk
    
    payment_proof = schemas.PaymentProofBase(
        filename=generated_filename,
        name=payment_proof_name,
        url=f'/app/backend/static/{generated_filename}',
        user_id=current_user.id,
        group_id=group_id if group_id else None
        )
    db_payment_proof = await crud.create_payment_proof(db, payment_proof)
    
    if not db_payment_proof:
        raise HTTPException(status_code=500, detail="Error while creating payment proof") 

    return schemas.PaymentProof(
        filename=db_payment_proof.filename,
        name=db_payment_proof.name,
        url=f"{request.base_url}static/{db_payment_proof.filename}",
        user_id=db_payment_proof.user_id,
        group_id=db_payment_proof.group_id,
        id=db_payment_proof.id
    )


@router.get("/payment_proofs/", tags=["payment_proofs"], response_model=list[schemas.PaymentProofPayments])
async def get_payment_proofs(request: Request,
                             start_date: Optional[datetime] = None,
                             end_date: Optional[datetime] = None, 
                             group_id: Optional[int] = None,
                             current_user: schemas.User = Depends(dependencies.get_current_user), 
                             db: AsyncSession = Depends(get_db)):
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        proofs = await crud.get_group_payment_proofs(db=db, group_id=group_id, start_date=start_date, end_date=end_date)
    else:
        proofs = await crud.get_user_payment_proofs(db=db, user_id=current_user.id, start_date=start_date, end_date=end_date)
    p = []
    for proof in proofs:
        p.append(schemas.PaymentProofPayments(
            filename=proof.filename,
            url=f'{request.base_url}static/{proof.filename}',
            user_id=proof.user_id,
            id=proof.id,
            name=proof.name,
            payments=[
                schemas.Payment(
                    id=payment.id,
                    name=payment.name,
                    type=payment.type,
                    category_id=payment.category_id,
                    cost=payment.cost,
                    payment_date=payment.payment_date,
                    category=schemas.Category(
                        id=payment.category.id,
                        category=payment.category.category,
                        user_id=payment.category.user_id
                    ) if payment.category else None
                ) for payment in proof.payments
            ]
        ))
    return p


@router.put("/payment_proofs/{payment_proof_id}/", tags=["payment_proofs"])
async def add_payments_to_payment_proof(payments: list[int],
                                        current_user: schemas.User = Depends(dependencies.get_current_user),
                                        payment_proof_id: int = Path(title="The ID of the payment to get"),
                                        db: AsyncSession = Depends(get_db)):
    if (payment_proof := await crud.get_payment_proof(db, payment_proof_id)):
        if payment_proof.user_id != current_user.id:
            raise HTTPException(status_code=403, detail="Forbidden")
        if payment_proof.group_id:
            if not (group := await crud.get_group(db, group_id=payment_proof.group_id)):
                raise HTTPException(status_code=404, detail="Group not found")
            if not group.is_member(current_user):
                raise HTTPException(status_code=403, detail="You don't belong to this group")
        if await crud.add_payment_to_payment_proof(db, payment_proof, payments):
            return True
        raise HTTPException(status_code=500, detail="Error while adding payment to payment proof")
    raise HTTPException(status_code=404, detail="Payment proof with given ID don't exist")


@router.delete("/payment_proofs/{payment_proof_id}/", tags=["payment_proofs"])
async def delete_payment_proof(current_user: schemas.User = Depends(dependencies.get_current_user),
                               payment_proof_id: int = Path(title="The ID of the payment to get"),
                               db: AsyncSession = Depends(get_db)):
    if (payment_proof := await crud.get_payment_proof(db, payment_proof_id)):
        if payment_proof.user_id != current_user.id:
            raise HTTPException(status_code=403, detail="Forbidden")
        if payment_proof.group_id:
            if not (group := await crud.get_group(db, group_id=payment_proof.group_id)):
                raise HTTPException(status_code=404, detail="Group not found")
            if not group.is_member(current_user):
                raise HTTPException(status_code=403, detail="You don't belong to this group")
        file_path = payment_proof.url
        if await crud.delete_payment(db, payment_proof):
            os.remove(file_path)
            return True
        raise HTTPException(status_code=500, detail="Error while deleting payment proof")
    raise HTTPException(status_code=404, detail="Payment proof with given ID don't exist")