from typing import Annotated, Union, Optional
from datetime import datetime
import uuid
import os

from fastapi import APIRouter, Depends, HTTPException, Path, UploadFile, Request
from sqlalchemy.ext.asyncio import AsyncSession
import aiofiles

from backend import crud, models, schemas, dependencies
from backend.database import get_db

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

    new_payment = await crud.create_payment(db=db, payment=payment)
    
    return new_payment


@router.get("/payments/", tags=["payments"], response_model=list[schemas.PaymentWithProof])
async def get_payments(request: Request,
                       start_date: Optional[datetime] = None,
                       end_date: Optional[datetime] = None, 
                       group_id: Optional[int] = None,
                       current_user: schemas.User = Depends(dependencies.get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    if group_id: # TODO - check if user is in group and if group exist
        return []
    
    return [
        schemas.PaymentWithProof(
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
            ),
            payment_proof_id=payment.payment_proof_id,
            payment_proof=schemas.PaymentProof(
                filename=payment.payment_proof.filename,
                url=f'{request.base_url}static/{payment.payment_proof.filename}',
                user_id=payment.payment_proof.user_id,
                id=payment.payment_proof.id,
            ) if payment.payment_proof else None
        ) for payment in await crud.get_user_payments(db=db, user_id=current_user.id, start_date=start_date, end_date=end_date)
    ]


@router.put("/payments/{payment_id}", tags=["payments"], response_model=schemas.Payment)
async def update_payments(payment_update: schemas.PaymentBase,
                          current_user: schemas.User = Depends(dependencies.get_current_user), 
                          payment_id: int = Path(title="The ID of the payment to get"),
                          db: AsyncSession = Depends(get_db)):
    if not (payment := await crud.get_payment(db=db, payment_id=payment_id)):
        raise HTTPException(status_code=404, detail=f"Payment doesn't exist")

    if payment.user_id != current_user.id: # also check for gorup
        raise HTTPException(status_code=403, detail=f"Forbidden")

    payment_update.user_id = current_user.id
    # there should be data validation... xd

    if not (updated  := await crud.update_payment(db=db, payment=payment, update_data=payment_update)):
        raise HTTPException(status_code=500, detail="Error while updating payment")
    print(updated)
    return updated


@router.delete("/payments/{payment_id}", tags=["payments"])
async def delete_payment(current_user: schemas.User = Depends(dependencies.get_current_user), 
                         payment_id: int = Path(title="The ID of the payment to get"),
                         db: AsyncSession = Depends(get_db)):
    if (payment := await crud.get_payment(db, payment_id)):
        if payment.user_id != current_user.id: # also check for gorup
            raise HTTPException(status_code=403, detail=f"Forbidden")
        if await crud.delete_payment(db, payment):
            return True
        raise HTTPException(status_code=500, detail="Error while deleting payment")
    raise HTTPException(status_code=404, detail="Payment with given ID don't exist")


@router.post("/payment_proofs/", tags=["payment_proofs"])
async def upload_payment_proof(current_user: schemas.User = Depends(dependencies.get_current_user),
                               file: Union[UploadFile, None] = None,
                               db: AsyncSession = Depends(get_db)):
    if not file:
        return {"message": "No upload file sent"}
    
    generated_filename = f'{current_user.username}-{uuid.uuid1()}-{file.filename}'
    async with aiofiles.open(f'/app/backend/static/{generated_filename}', 'wb') as out_file:
        while content := await file.read(1024):  # async read chunk
            await out_file.write(content)  # async write chunk
    
    payment_proof = schemas.PaymentProofBase(
        filename=generated_filename,
        url=f'/app/backend/static/{generated_filename}',
        user_id=current_user.id
        )
    db_payment_proof = await crud.create_payment_proof(db, payment_proof)
    return db_payment_proof


@router.get("/payment_proofs/", tags=["payment_proofs"], response_model=list[schemas.PaymentProofPayments])
async def get_payment_proofs(request: Request,
                             start_date: Optional[datetime] = None,
                             end_date: Optional[datetime] = None, 
                             group_id: Optional[int] = None,
                             current_user: schemas.User = Depends(dependencies.get_current_user), 
                             db: AsyncSession = Depends(get_db)):
    if group_id: # TODO - check if user is in group and if group exist
        return []
    proofs = await crud.get_user_payment_proofs(db=db, user_id=current_user.id, start_date=start_date, end_date=end_date)
    print()
    p = []
    for proof in proofs:
        p.append(schemas.PaymentProofPayments(
            filename=proof.filename,
            url=f'{request.base_url}static/{proof.filename}',
            user_id=proof.user_id,
            id=proof.id,
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
                    )
                ) for payment in proof.payments
            ]
        ))
    return p


@router.put("/payment_proofs/{payment_proof_id}", tags=["payment_proofs"])
async def add_payments_to_payment_proof(payments: list[int],
                                        current_user: schemas.User = Depends(dependencies.get_current_user),
                                        payment_proof_id: int = Path(title="The ID of the payment to get"),
                                        db: AsyncSession = Depends(get_db)):
    if (payment_proof := await crud.get_payment_proof(db, payment_proof_id)):
        if payment_proof.user_id != current_user.id:
            raise HTTPException(status_code=403, detail="Forbidden")
        if await crud.add_payment_to_payment_proof(db, payment_proof, payments):
            return True
        raise HTTPException(status_code=500, detail="Error while adding payment to payment proof")
    raise HTTPException(status_code=404, detail="Payment proof with given ID don't exist")


@router.delete("/payment_proofs/{payment_proof_id}", tags=["payment_proofs"])
async def delete_payment_proof(current_user: schemas.User = Depends(dependencies.get_current_user),
                               payment_proof_id: int = Path(title="The ID of the payment to get"),
                               db: AsyncSession = Depends(get_db)):
    if (payment_proof := await crud.get_payment_proof(db, payment_proof_id)):
        if payment_proof.user_id != current_user.id:
            raise HTTPException(status_code=403, detail="Forbidden")
        file_path = payment_proof.url
        if await crud.delete_payment(db, payment_proof):
            os.remove(file_path)
            return True
        raise HTTPException(status_code=500, detail="Error while deleting payment proof")
    raise HTTPException(status_code=404, detail="Payment proof with given ID don't exist")