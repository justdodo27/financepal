from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import bcrypt

from datetime import datetime
from typing import Optional

from backend import models, schemas

# USERS
async def get_user(db: AsyncSession, user_id: int):
    q = select(models.User).filter(models.User.id == user_id)
    result = await db.execute(q)
    return result.scalars().first()


async def get_user_by_email(db: AsyncSession, email: str):
    q = select(models.User).filter(models.User.email == email)
    result = await db.execute(q)
    return result.scalars().first()


async def get_user_by_username(db: AsyncSession, username: str):
    q = select(models.User).filter(models.User.username == username)
    result = await db.execute(q)
    return result.scalars().first()


async def get_users(db: AsyncSession):
    q = select(models.User)
    results = await db.execute(q)
    return results.scalars().all()


async def create_user(db: AsyncSession, user: schemas.UserCreate):
    hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt(14))
    db_user = models.User(
        email=user.email,
        username=user.username,
        password_hash=hashed_password.decode()
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

# CATEGORIES
async def get_category(db: AsyncSession, category_id: int):
    q = select(models.Category).filter(models.Category.id == category_id)
    result = await db.execute(q)
    return result.scalars().first()


async def get_categories(db: AsyncSession):
    q = select(models.Category).filter(
        models.Category.user_id.is_(None) # TODO Syra <- dodaj tu warunek,e group_id is none XD
    )
    result = await db.execute(q)
    return result.scalars().all()


async def get_categories_by_user_id(db: AsyncSession, user_id: int):
    q = select(models.Category).filter(
        models.Category.user_id == user_id
    )
    result = await db.execute(q)
    return result.scalars().all()


# async def get_categories_by_group_id(db: AsyncSession, group_id: int):
#     q = select(models.Category).limit(
#         models.Category.group_id == group_id
#     )
#     result = await db.execute(q)
#     return result.scalars().all()


async def create_category(db: AsyncSession, category: schemas.CategoryCreate):
    db_category = models.Category(
        category=category.category,
        user_id=category.user_id
    )
    db.add(db_category)
    await db.commit()
    await db.refresh(db_category)
    return db_category


async def update_category(db: AsyncSession, category: models.Category, update_data: schemas.CategoryCreate):
    try:
        category.category = update_data.category
        await db.commit()
        await db.refresh(category)
    except Exception as e:
        return False
    return category


async def delete_category(db: AsyncSession, category: models.Category):
    try:
        await db.delete(category)
        await db.commit()
    except Exception as e:
        return False
    return True

# PAYMENTS
async def get_payment(db: AsyncSession, payment_id: int):
    q = select(models.Payment).filter(models.Payment.id == payment_id)
    result = await db.execute(q)
    return result.scalars().first()


async def get_user_payments(db: AsyncSession, user_id: int, start_date: Optional[datetime], end_date: Optional[datetime]):
    q = select(models.Payment).filter(
        models.Payment.user_id == user_id,
        (models.Payment.payment_date >= start_date.replace(tzinfo=None)) if start_date else True,
        (models.Payment.payment_date <= end_date.replace(tzinfo=None)) if end_date else True
    )
    result = await db.execute(q)
    return result.scalars().all()


# async def get_group_payments(db: AsyncSession, group_id: int):
#     q = select(models.Payment).filter(
#         models.Payment.group_id == group_id
#     )
#     result = await db.execute(q)
#     return result.scalars().all()


async def create_payment(db: AsyncSession, payment: schemas.PaymentBase):
    payment_date = payment.payment_date.replace(tzinfo=None)

    db_payment = models.Payment(
        name=payment.name,
        type=payment.type,
        category_id=payment.category_id,
        user_id=payment.user_id,
        cost=payment.cost,
        payment_date=payment_date,
        payment_proof_id=payment.payment_proof_id,
        # group_id
    )
    
    db.add(db_payment)
    await db.commit()
    await db.refresh(db_payment)
    return db_payment


async def update_payment(db: AsyncSession, payment: models.Payment, update_data: schemas.PaymentBase):
    try:
        payment.name = update_data.name
        payment.type = update_data.type
        payment.category_id = update_data.category_id
        payment.cost = update_data.cost
        payment.payment_date = update_data.payment_date.replace(tzinfo=None)

        await db.commit()
        await db.refresh(payment)
    except Exception as e:
        print(e)
        return False
    return payment


async def delete_payment(db: AsyncSession, payment: models.Payment):
    try:
        await db.delete(payment)
        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True


async def create_payment_proof(db: AsyncSession, payment_proof: models.PaymentProof):
    try:
        db_payment_proof = models.PaymentProof(
            filename=payment_proof.filename,
            url=payment_proof.url,
            user_id=payment_proof.user_id
        )

        db.add(db_payment_proof)
        await db.commit()
        await db.refresh(db_payment_proof)
        return db_payment_proof
    except Exception as e:
        print(e)
        return False
    
async def get_payment_proof(db: AsyncSession, payment_proof_id: int):
    q = select(models.PaymentProof).filter(models.PaymentProof.id == payment_proof_id)
    result = await db.execute(q)
    return result.scalars().first()

async def get_user_payment_proofs(db: AsyncSession, user_id: int, start_date: Optional[datetime], end_date: Optional[datetime]):
    q = select(models.PaymentProof).filter(
        models.PaymentProof.user_id == user_id,
        (models.PaymentProof.payments.payment_date >= start_date.replace(tzinfo=None)) if start_date else True,
        (models.PaymentProof.payments.payment_date <= end_date.replace(tzinfo=None)) if end_date else True
    )
    result = await db.execute(q)
    return result.scalars().all()

async def add_payment_to_payment_proof(db: AsyncSession, payment_proof: models.PaymentProof, payments_ids: list[int]):
    q = select(models.Payment).filter(models.Payment.id.in_(payments_ids))
    result = await db.execute(q)
    payments = result.scalars().all()

    try:
        for payment in payments:
            payment.payment_proof_id = payment_proof.id
        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True

async def delete_payment_proof(db: AsyncSession, payment_proof: models.PaymentProof):
    try:
        await db.delete(payment_proof)
        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True