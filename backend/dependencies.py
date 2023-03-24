from typing import Annotated

from backend import crud, database

from fastapi import Header, HTTPException, Depends, status
from jose import JWTError, jwt
from fastapi.security import OAuth2PasswordBearer
import bcrypt
from sqlalchemy.ext.asyncio import AsyncSession


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
SECRET_KEY = "thats_a_secret!"
ALGORITHM = "HS256"


async def authenticate_user(db: AsyncSession, login: str, password: str):
    user_by_username = await crud.get_user_by_username(db, username=login)
    user_by_email = await crud.get_user_by_email(db, email=login)
    user = user_by_username if user_by_username else user_by_email if user_by_email else None
    if not user:
        return False
    if not bcrypt.checkpw(password.encode(), user.password_hash.encode()):
        return False
    return user


def create_access_token(data: dict):
    to_encode = data.copy()
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(db: Annotated[AsyncSession, Depends(database.get_db)], token: Annotated[str, Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
        user_id = int(user_id)
    except JWTError as err:
        raise credentials_exception
    user = await crud.get_user(db, user_id=user_id)
    if user is None:
        raise credentials_exception
    return user