from typing import Union

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


# @router.get("/users/notifications/", tags=["users"], response_model=bool)
# async def check_notifications(
#     current_user: schemas.User = Depends(dependencies.get_current_user),
#     db: AsyncSession = Depends(get_db)
# ):
#     user = await crud.get_user(db, user_id=current_user.id)
#     if user.notifications_token:
#         return True
#     return False


# @router.put("/users/notifications/", tags=["users"])
# async def update_token(
#     token: Union[str, None] = None,
#     current_user: schemas.User = Depends(dependencies.get_current_user),
#     db: AsyncSession = Depends(get_db)
# ):
#     if await crud.update_notification_token(db, current_user, token):
#         return True
#     return HTTPException(status_code=400, detail="Cannot update the token")