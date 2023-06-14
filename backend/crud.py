from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import delete, or_, func, and_
import bcrypt

from datetime import datetime
from typing import Optional, Union
import calendar

from backend import models, schemas

# USERS
async def get_user(db: AsyncSession, user_id: int):
    q = select(models.User).filter(models.User.id == user_id)
    result = await db.execute(q)
    return result.scalars().first()


async def get_users_list(db: AsyncSession, users_ids: list[int], group_id: int):
    q = select(models.User).filter(
        models.User.id.in_(users_ids),
        models.User.groups.any(models.Group.id == group_id)
    )
    result = await db.execute(q)
    return result.scalars().all()


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


async def update_notification_token(db: AsyncSession, user: models.User, token: Union[str, None]):
    try:
        user.notifications_token = token
        await db.commit()
        await db.refresh(user)
    except Exception as e:
        print(e)
        return False
    return user

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


async def get_categories_by_group_id(db: AsyncSession, group_id: int):
    q = select(models.Category).filter(
        models.Category.group_id == group_id
    )
    result = await db.execute(q)
    return result.scalars().all()


async def create_category(db: AsyncSession, category: schemas.CategoryCreate):
    db_category = models.Category(
        category=category.category,
        user_id=category.user_id,
        group_id=category.group_id,
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
    ).order_by(models.Payment.payment_date)
    result = await db.execute(q)
    return result.scalars().all()


async def get_group_payments(db: AsyncSession, group_id: int, start_date: Optional[datetime], end_date: Optional[datetime]):
    q = select(models.Payment).filter(
        models.Payment.group_id == group_id,
        (models.Payment.payment_date >= start_date.replace(tzinfo=None)) if start_date else True,
        (models.Payment.payment_date <= end_date.replace(tzinfo=None)) if end_date else True
    ).order_by(models.Payment.payment_date)
    result = await db.execute(q)
    return result.scalars().all()


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
        renewable_id=payment.renewable_id,
        group_id=payment.group_id
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
        payment.payment_proof_id = update_data.payment_proof_id
        payment.renewable_id = update_data.renewable_id

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


async def create_payment_proof(db: AsyncSession, payment_proof: schemas.PaymentProofBase):
    try:
        db_payment_proof = models.PaymentProof(
            filename=payment_proof.filename,
            url=payment_proof.url,
            name=payment_proof.name,
            user_id=payment_proof.user_id,
            group_id=payment_proof.group_id,
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


async def get_group_payment_proofs(db: AsyncSession, group_id: int, start_date: Optional[datetime], end_date: Optional[datetime]):
    q = select(models.PaymentProof).filter(
        models.PaymentProof.group_id == group_id,
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


async def create_renewable(db: AsyncSession, renewable: schemas.RenewableBase):
    payment_date = renewable.payment_date.replace(tzinfo=None)

    db_renewable = models.Renewable(
        name=renewable.name,
        type=renewable.type,
        category_id=renewable.category_id,
        user_id=renewable.user_id,
        cost=renewable.cost,
        period=renewable.period,
        payment_date=payment_date,
        # group_id
    )
    
    db.add(db_renewable)
    await db.commit()
    await db.refresh(db_renewable)
    return db_renewable


async def get_user_renewables(db: AsyncSession, user_id: int):
    q = select(models.Renewable).filter(
        models.Renewable.user_id == user_id,
        models.Renewable.deleted_at.is_(None)
    )
    result = await db.execute(q)
    return result.scalars().all()


async def get_group_renewables(db: AsyncSession, group_id: int):
    q = select(models.Renewable).filter(
        models.Renewable.group_id == group_id,
        models.Renewable.deleted_at.is_(None)
    )
    result = await db.execute(q)
    return result.scalars().all()


# async def get_user_awaiting_renewables(db: AsyncSession, start_date: Optional[datetime], end_date: Optional[datetime], renewable_id: int):
#     q = select(models.Payment).filter(
#         models.Payment.renewable_id == renewable_id,
#         (models.Payment.payment_date >= start_date.replace(tzinfo=None)) if start_date else True,
#         (models.Payment.payment_date <= end_date.replace(tzinfo=None)) if end_date else True
#     )
#     result = await db.execute(q)
#     return result.scalars().all()


async def get_last_payment_for_renewable(db: AsyncSession, renewable_id: int):
    q = select(models.Payment).filter(
        models.Payment.renewable_id == renewable_id
    ).order_by(models.Payment.payment_date.desc())
    result = await db.execute(q)
    return result.scalars().first()


async def get_renewable(db: AsyncSession, renewable_id: int):
    q = select(models.Renewable).filter(models.Renewable.id == renewable_id, models.Renewable.deleted_at.is_(None))
    result = await db.execute(q)
    return result.scalars().first()


async def update_renewable(db: AsyncSession, renewable: models.Renewable, update_data: schemas.RenewableBase):
    try:
        renewable.name = update_data.name
        renewable.type = update_data.type
        renewable.category_id = update_data.category_id
        renewable.cost = update_data.cost
        renewable.period = update_data.period
        renewable.payment_date = update_data.payment_date.replace(tzinfo=None)

        await db.commit()
        await db.refresh(renewable)
    except Exception as e:
        print(e)
        return False
    return renewable


async def delete_renewable(db: AsyncSession, renewable: models.Renewable):
    try:
        renewable.deleted_at = datetime.utcnow()
        await db.commit()
        await db.refresh(renewable)
    except Exception as e:
        print(e)
        return False
    return True


async def create_group(db: AsyncSession, group: schemas.GroupBase, group_code: str):
    db_group = models.Group(
        name=group.name,
        group_code=group_code,
        user_id=group.user_id
    )

    db.add(db_group)
    await db.commit()
    await db.refresh(db_group)
    return db_group


async def get_group(db: AsyncSession, group_id: int) -> models.Group:
    q = select(models.Group).filter(
        models.Group.id == group_id
    )

    result = await db.execute(q)
    return result.scalars().first()


async def get_user_groups(db: AsyncSession, user: models.User):
    q = select(models.Group).filter(
        or_(
            models.Group.user_id == user.id,
            models.Group.members.any(models.User.id == user.id)
        )
    )

    results = await db.execute(q)
    return results.scalars().all()


async def get_group_by_code(db: AsyncSession, group_code: str) -> models.Group:
    q = select(models.Group).filter(
        models.Group.group_code == group_code
    )

    result = await db.execute(q)
    return result.scalars().first()


async def edit_group(db: AsyncSession, group: models.Group, updated_data: schemas.GroupBase, group_code: Union[str, None], users_to_kick: list[models.User]) -> models.Group:
    try:
        group.name = updated_data.name
        if group_code:
            group.group_code = group_code 
        for user in users_to_kick:
            group.members.remove(user)
        await db.commit()
        await db.refresh(group)
    except Exception as e:
        return False
    return group


async def add_to_group(db: AsyncSession, group: models.Group, user: models.User):
    try:
        group.members.append(user)

        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True


async def remove_from_group(db: AsyncSession, group: models.Group, user: models.User):
    try:
        group.members.remove(user)

        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True


async def delete_group(db: AsyncSession, group: models.Group):
    try:
        group.members.clear()

        payment_proofs_ids = [ payment.payment_proof_id for payment  in group.payments if payment.payment_proof_id is not None]

        q1 = delete(models.PaymentProof).filter(
            models.PaymentProof.id.in_(payment_proofs_ids)
        )
        await db.execute(q1)
        group.payments.clear()

        await db.delete(group)
        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True


# LIMITS

async def create_limit(db: AsyncSession, limit: schemas.LimitBase):
    db_limit = models.Limit(
        value=limit.value,
        user_id=limit.user_id,
        group_id=limit.group_id,
        period=limit.period,
        is_active=limit.is_active
    )

    db.add(db_limit)
    await db.commit()
    await db.refresh(db_limit)
    return db_limit


async def get_limit(db: AsyncSession, limit_id: int):
    q = select(models.Limit).filter(
        models.Limit.id == limit_id
    )

    result = await db.execute(q)
    return result.scalars().first()


async def get_user_limits(db: AsyncSession, user_id: int):
    q = select(models.Limit).filter(
        models.Limit.user_id == user_id,
        models.Limit.group_id == None
    )

    result = await db.execute(q)
    return result.scalars().all()


async def get_group_limits(db: AsyncSession, group_id: int):
    q = select(models.Limit).filter(
        models.Limit.group_id == group_id
    )

    result = await db.execute(q)
    return result.scalars().all()


async def update_limit(db: AsyncSession, limit: models.Limit, updated_data: schemas.LimitBase):
    try:
        limit.value = updated_data.value
        limit.period = updated_data.period
        limit.is_active = updated_data.is_active
        limit.n05_sent_at = None
        limit.n20_sent_at = None
        limit.nX_sent_at = None

        await db.commit()
        await db.refresh(limit)
    except Exception as e:
        return False
    return limit


async def remove_limit(db: AsyncSession, limit: models.Limit):
    try:
        await db.delete(limit)
        await db.commit()
    except Exception as e:
        print(e)
        return False
    return True

# STATISTICS

async def categories_grouped(db: AsyncSession, start_date: datetime, end_date: datetime, user_id: Union[int, None], group_id: Union[int, None]):
    if group_id:
        q = select(
            models.Category.id,
            models.Category.category,
            func.sum(models.Payment.cost).label("category_sum"),
            func.count(models.Payment.id).label("category_count")
        ).select_from(
            models.Category
        ).join(
            models.Payment, models.Payment.category_id == models.Category.id
        ).filter(
            models.Payment.group_id == group_id,
            models.Payment.payment_date >= start_date.replace(tzinfo=None),
            models.Payment.payment_date <= end_date.replace(tzinfo=None)
        ).group_by(
            models.Category.id,
            models.Category.category
        ).having(
            func.sum(models.Payment.cost) > 0
        )
    else:
        q = select(
            models.Category.id,
            models.Category.category,
            func.sum(models.Payment.cost).label("category_sum"),
            func.count(models.Payment.id).label("category_count")
        ).select_from(
            models.Category
        ).join(
            models.Payment, models.Payment.category_id == models.Category.id
        ).filter(
            models.Payment.user_id == user_id,
            models.Payment.payment_date >= start_date.replace(tzinfo=None),
            models.Payment.payment_date <= end_date.replace(tzinfo=None)
        ).group_by(
            models.Category.id,
            models.Category.category
        ).having(
            func.sum(models.Payment.cost) > 0
        )

    results = await db.execute(q)

    return results.all()

# "TRIGGERS"

async def check_limit(db: AsyncSession, user_id: Union[int, None], group_id: Union[int, None]):
    if group_id:
        query_filter = (models.Limit.group_id == group_id)
    elif user_id:
        query_filter = (models.Limit.user_id == user_id)
    else: 
        raise Exception("No user ID or group ID provided!")
    
    start_date = datetime.utcnow().replace(day=1)
    end_date = datetime.utcnow().replace(day=calendar.monthrange(year=start_date.year, month=start_date.month)[1])

    q = select(models.Limit).add_columns(
        models.Limit.n05_sent_at,
        models.Limit.n20_sent_at,
        models.Limit.nX_sent_at,
        models.Limit.period,
        models.Limit.id,
        func.sum(models.Payment.cost).label("payments_sum"),
        (func.sum(models.Payment.cost)/models.Limit.value).label("percentage")
    ).join(
        models.Payment, 
        and_(
            (models.Payment.user_id == models.Limit.user_id) if user_id else True,
            (models.Payment.group_id == models.Limit.group_id) if group_id else True,
            models.Payment.payment_date >= start_date,
            models.Payment.payment_date <= end_date
        )
    ).filter(
        query_filter,
        models.Limit.is_active == True
    ).group_by(
        models.Limit.id,
    ).having(
        (func.sum(models.Payment.cost)/models.Limit.value) > 0.8
    )

    results = await db.execute(q)

    return results.all()


async def update_limits_sents(db: AsyncSession, limit: models.Limit, sent_type: str):
    try:
        if sent_type == 'n20':
            limit.n20_sent_at = datetime.utcnow()
        elif sent_type == 'n05':
            limit.n05_sent_at = datetime.utcnow()
        elif sent_type == 'nX':
            limit.nX_sent_at = datetime.utcnow()
    except Exception as e:
        return False
    return limit
    