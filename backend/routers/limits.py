from typing import Annotated, Union, Optional
from datetime import datetime
import uuid
import os

from fastapi import APIRouter, Depends, HTTPException, Path, UploadFile, Request
from sqlalchemy.ext.asyncio import AsyncSession
import aiofiles

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])

@router.post("/limits/", tags=["limits"], response_model=schemas.Limit)
async def create_limit(limit: schemas.LimitBase,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       db: AsyncSession = Depends(get_db)):
    limit.user_id = current_user.id

    if not limit.value or limit.value <= 0:
        raise HTTPException(status_code=409, detail="Limit value must be greater than 0")
    limit_db = await crud.create_limit(db, limit)

    return limit_db


@router.get("/limits/", tags=["limits"], response_model=schemas.Limit)
async def get_limits(current_user: schemas.User = Depends(dependencies.get_current_user),
                     db: AsyncSession = Depends(get_db)):
    limits = await crud.get_user_limits(db, current_user.id)

    return limits


@router.put("/limits/{limit_id}/", tags=["limits"])
async def update_limit(limit_data: schemas.LimitBase,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       limit_id: int = Path(title="Limit ID to update"),
                       db: AsyncSession = Depends(get_db)):
    if not (limit := await crud.get_limit(db, limit_id)):
        raise HTTPException(status_code=404, detail=f"Limit doesn't exist")
    
    if limit.group_id:
        group = await crud.get_group(db, limit.group_id)
        group_members = group.members
        group_owner_id = group.user_id
    else:
        group_members = [current_user]

    # check whether user "own" the limit or user belongs to group where the limit is joined
    if limit.user_id != current_user.id and (current_user not in group_members or current_user.id != group_owner_id):
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    updated_limit = await crud.update_limit(db, limit, limit_data)

    return update_limit
    

@router.delete("/limits/{limit_id}/", tags=["limits"])
async def delete_limit(current_user: schemas.User = Depends(dependencies.get_current_user),
                       limit_id: int = Path(title="Limit ID to update"),
                       db: AsyncSession = Depends(get_db)):
    if not (limit := await crud.get_limit(db, limit_id)):
        raise HTTPException(status_code=404, detail=f"Limit doesn't exist")
    
    if limit.group_id:
        group = await crud.get_group(db, limit.group_id)
        group_members = group.members
        group_owner_id = group.user_id
    else:
        group_members = [current_user]

    # check whether user "own" the limit or user belongs to group where the limit is joined
    if limit.user_id != current_user.id and (current_user not in group_members or current_user.id != group_owner_id):
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    if await crud.remove_limit(db, limit):
        return True
    
    raise HTTPException(status_code=500, detail="Error while deleteing limit")