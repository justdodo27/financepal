from typing import Annotated, Union, Optional
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.ext.asyncio import AsyncSession

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


@router.get("/payments/", tags=["payments"], response_model=list[schemas.Payment])
async def get_payments(start_date: Optional[datetime] = None,
                       end_date: Optional[datetime] = None, 
                       group_id: Optional[int] = None,
                       current_user: schemas.User = Depends(dependencies.get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    if group_id: # TODO - check if user is in group and if group exist
        return []
    return await crud.get_user_payments(db=db, user_id=current_user.id, start_date=start_date, end_date=end_date)


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