from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])


@router.post("/users/", tags=["users"], response_model=schemas.User)
async def create_user(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_email(db, email=user.email)
    db_user2 = await crud.get_user_by_username(db, username=user.username)
    if db_user2 or db_user:
        raise HTTPException(status_code=400, detail="User with given username or email already exist")
    return await crud.create_user(db=db, user=user)


@router.get("/users/me/", tags=["users"], response_model=schemas.User)
async def read_users_me(
    current_user: schemas.User = Depends(dependencies.get_current_user)
):
    return current_user


@router.put("/users/", tags=["users"])
async def update_token(
    token: str,
    current_user: schemas.User = Depends(dependencies.get_current_user),
    db: AsyncSession = Depends(get_db)
):
    if await crud.update_notification_token(db, current_user, token):
        return True
    return HTTPException(status_code=400, detail="Cannot update the token")