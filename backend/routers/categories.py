from typing import Annotated, Union, Optional

from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])


@router.post("/categories/", tags=["categories"], response_model=schemas.Category)
async def create_category(category: schemas.CategoryCreate, 
                          current_user: schemas.User = Depends(dependencies.get_current_user),
                          db: AsyncSession = Depends(get_db)):
    if category.user_id is not None:
        category.user_id = current_user.id
    else:
        category.user_id = None
    
    if category.group_id:
        if not (group := await crud.get_group(db, group_id=category.group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
    
    return await crud.create_category(db=db, category=category)


@router.get("/categories/", tags=["categories"], response_model=list[schemas.Category])
async def get_categories(group_id: Optional[int] = None, 
                         current_user: schemas.User = Depends(dependencies.get_current_user), 
                         db: AsyncSession = Depends(get_db)):
    results = await crud.get_categories(db)
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        results += await crud.get_categories_by_group_id(db, group_id)
    else:
        results += await crud.get_categories_by_user_id(db, current_user.id)

    return results


@router.delete("/categories/{category_id}/", tags=["categories"])
async def delete_category(current_user: schemas.User = Depends(dependencies.get_current_user),
                          category_id: int = Path(title="The ID of the category to get"),
                          db: AsyncSession = Depends(get_db)):
    if (category := await crud.get_category(db, category_id)):
        if not category.user_id and not category.group_id:
            raise HTTPException(status_code=400, detail="You cannot remove global category")
        # TODO check if user has right permissions to remove category
        if await crud.delete_category(db, category):
            return True
        raise HTTPException(status_code=500, detail="Error when deleting")
    raise HTTPException(status_code=404, detail="Category with given ID don't exist")


@router.put("/categories/{category_id}/", tags=["categories"], response_model=schemas.Category)
async def update_category(category_update: schemas.CategoryCreate,
                          current_user: schemas.User = Depends(dependencies.get_current_user),
                          category_id: int = Path(title="The ID of the category to get"),
                          db: AsyncSession = Depends(get_db)):
    if (category := await crud.get_category(db, category_id)):
        # TODO check is user has right permissions to update category
        if updated_category := await crud.update_category(db, category, category_update):
            return updated_category
        raise HTTPException(status_code=500, detail="Error when updating")
    raise HTTPException(status_code=404, detail="Category with given ID don't exist")
