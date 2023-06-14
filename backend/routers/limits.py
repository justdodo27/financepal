from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])

@router.post("/limits/", tags=["limits"], response_model=schemas.Limit)
async def create_limit(limit: schemas.LimitBase,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       db: AsyncSession = Depends(get_db)):
    limit.user_id = current_user.id

    if limit.group_id:
        if not (group := await crud.get_group(db, group_id=limit.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    if not limit.value or limit.value <= 0:
        raise HTTPException(status_code=409, detail="Limit value must be greater than 0")
    limit_db = await crud.create_limit(db, limit)

    return schemas.Limit(
        value=limit_db.value,
        user_id=limit_db.user_id,
        is_active=limit_db.is_active,
        group_id=limit_db.group_id,
        period=limit_db.period,
        id=limit_db.id,
    )


@router.get("/limits/", tags=["limits"], response_model=list[schemas.Limit])
async def get_limits(group_id: Optional[int] = None,
                     current_user: schemas.User = Depends(dependencies.get_current_user),
                     db: AsyncSession = Depends(get_db)):
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        limits = await crud.get_group_limits(db, group_id)
    else:
        limits = await crud.get_user_limits(db, current_user.id)

    return [schemas.Limit(
        value=limit.value,
        user_id=limit.user_id,
        group_id=limit.group_id,
        period=limit.period,
        id=limit.id,
        is_active=limit.is_active,
    ) for limit in limits]


@router.put("/limits/{limit_id}/", tags=["limits"])
async def update_limit(limit_data: schemas.LimitBase,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       limit_id: int = Path(title="Limit ID to update"),
                       db: AsyncSession = Depends(get_db)):
    if not (limit := await crud.get_limit(db, limit_id)):
        raise HTTPException(status_code=404, detail=f"Limit doesn't exist")

    if limit.group_id:
        if not (group := await crud.get_group(db, group_id=limit.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    if limit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    updated_limit = await crud.update_limit(db, limit, limit_data)

    return updated_limit
    

@router.delete("/limits/{limit_id}/", tags=["limits"])
async def delete_limit(current_user: schemas.User = Depends(dependencies.get_current_user),
                       limit_id: int = Path(title="Limit ID to update"),
                       db: AsyncSession = Depends(get_db)):
    if not (limit := await crud.get_limit(db, limit_id)):
        raise HTTPException(status_code=404, detail=f"Limit doesn't exist")
    
    if limit.group_id:
        if not (group := await crud.get_group(db, group_id=limit.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")

    if limit.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"Forbidden")
    
    if await crud.remove_limit(db, limit):
        return True
    
    raise HTTPException(status_code=500, detail="Error while deleteing limit")