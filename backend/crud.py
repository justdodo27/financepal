from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import bcrypt

from backend import models, schemas


async def get_user(db: AsyncSession, user_id: int):
    q = select(models.User).filter(models.User.id == user_id)
    result = await db.execute(q)
    return result.first()


async def get_user_by_email(db: AsyncSession, email: str):
    q = select(models.User).filter(models.User.email == email)
    result = await db.execute(q)
    return result.first()


async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    q = select(models.User).offset(skip).limit(limit)
    results = await db.execute(q)
    return results.all()


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