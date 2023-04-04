from typing import Annotated, Union

from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, models, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])


@router.post("/categories/", tags=["categories"], response_model=schemas.Category)
async def create_category(category: schemas.CategoryCreate, db: AsyncSession = Depends(get_db)):
    if category.user_id and not (user := await crud.get_user(db, user_id=category.user_id)):
        return HTTPException(status_code=400, detail="User with given ID don't exist")
    # same stuff with group ^^^
    return await crud.create_category(db=db, category=category)


@router.get("/categories/", tags=["categories"], response_model=list[schemas.Category])
async def get_categories(user_id: Union[int, None] = None,
                         group_id: Union[int, None] = None, 
                         current_user: schemas.User = Depends(dependencies.get_current_user), 
                         db: AsyncSession = Depends(get_db)):
    results = await crud.get_categories(db)
    if user_id:
        results += await crud.get_categories_by_user_id(db, user_id)
    # add same stuff for groups ^^^^^
    return results


@router.delete("/categories/{category_id}", tags=["categories"])
async def delete_category(current_user: schemas.User = Depends(dependencies.get_current_user),
                          category_id: int = Path(title="The ID of the category to get"),
                          db: AsyncSession = Depends(get_db)):
    if (category := await crud.get_category(db, category_id)):
        if await crud.delete_category(db, category):
            return True
        raise HTTPException(status_code=500, detail="Error when deleting")
    raise HTTPException(status_code=404, detail="Category with given ID don't exist")


@router.put("/categories/{category_id}", tags=["categories"], response_model=schemas.Category)
async def update_category(category_update: schemas.CategoryCreate,
                          current_user: schemas.User = Depends(dependencies.get_current_user),
                          category_id: int = Path(title="The ID of the category to get"),
                          db: AsyncSession = Depends(get_db)):
    if (category := await crud.get_category(db, category_id)):
        if updated_category := await crud.update_category(db, category, category_update):
            return updated_category
        raise HTTPException(status_code=500, detail="Error when updating")
    raise HTTPException(status_code=404, detail="Category with given ID don't exist")
