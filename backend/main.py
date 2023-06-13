from typing import Annotated

from fastapi import Depends, FastAPI, status, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.staticfiles import StaticFiles
from sqlalchemy.ext.asyncio import AsyncSession
import firebase_admin
from firebase_admin import credentials

from backend import schemas, crud
from backend.dependencies import authenticate_user, create_access_token
from backend.routers import users, categories, payments, renewables, groups, statistics, limits
from backend.database import engine, Base, get_db
from backend.dataset import generate_dataset

cred = credentials.Certificate("./serviceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)

app = FastAPI()

app.mount("/static", StaticFiles(directory="/app/backend/static"), name="static")

app.include_router(users.router)
app.include_router(categories.router)
app.include_router(payments.router)
app.include_router(renewables.router)
app.include_router(groups.router)
app.include_router(statistics.router)
app.include_router(limits.router)


@app.get("/")
async def root():
    return {"message": "Hello!"}


@app.get("/clean_db")
async def clean():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    return True


@app.get("/reset_db")
async def reset(db: AsyncSession = Depends(get_db)):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    try:
        await generate_dataset(db)
    except Exception as e:
        print(e)
        return False
    return True


@app.post("/token", response_model=schemas.Token)
async def login_for_access_token(
    form_data: Annotated[schemas.AuthorizationModel, Depends()],
    db: AsyncSession = Depends(get_db)
):
    user = await authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect login or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if form_data.token:
        await crud.update_notification_token(db, user, token=form_data.token)
    access_token = create_access_token(
        data={"sub": str(user.id)}
    )
    return {"access_token": access_token, "token_type": "bearer"}