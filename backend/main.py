from fastapi import Depends, FastAPI

from backend import models
from backend.dependencies import get_query_token, get_token_header
from backend.routers import users
from backend.database import SessionLocal, engine, Base

app = FastAPI(dependencies=[Depends(get_query_token)])


app.include_router(users.router)


@app.on_event("startup")
async def init_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)

@app.get("/")
async def root():
    return {"message": "Hello xd!"}