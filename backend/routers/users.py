from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])


@router.post("/users/", tags=["users"], response_model=schemas.User, dependencies=[])
async def create_user(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return await crud.create_user(db=db, user=user)


@router.get("/users/me/", tags=["users"], response_model=schemas.User)
async def read_users_me(
    current_user: schemas.User = Depends(dependencies.get_current_user)
):
    return current_user