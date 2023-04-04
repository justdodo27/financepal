from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import bcrypt

from backend import models, schemas


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