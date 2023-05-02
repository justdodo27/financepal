from typing import Annotated

from fastapi import Depends, FastAPI, status, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.staticfiles import StaticFiles
from sqlalchemy.ext.asyncio import AsyncSession

from backend import schemas
from backend.dependencies import authenticate_user, create_access_token
from backend.routers import users, categories, payments, renewables
from backend.database import engine, Base, get_db
from backend.dataset import generate_dataset

app = FastAPI()

app.mount("/static", StaticFiles(directory="/app/backend/static"), name="static")

app.include_router(users.router)
app.include_router(categories.router)
app.include_router(payments.router)
app.include_router(renewables.router)


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
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    db: AsyncSession = Depends(get_db)
):
    user = await authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect login or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(
        data={"sub": str(user.id)}
    )
    return {"access_token": access_token, "token_type": "bearer"}