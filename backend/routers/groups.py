
from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.ext.asyncio import AsyncSession
import strgen

from backend import crud, schemas, dependencies
from backend.database import get_db

router = APIRouter(dependencies=[])


@router.post("/groups/", tags=["groups"], response_model=schemas.Group)
async def create_group(group: schemas.GroupBase,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       db: AsyncSession = Depends(get_db)):
    group.user_id = current_user.id

    if not group.name or len(group.name) == 0:
        raise HTTPException(status_code=409, detail="Group name is required")
    group_code = strgen.StringGenerator("[\w\d]{6}").render()

    group_db = await crud.create_group(db, group, group_code)

    return group_db


@router.get("/groups/", tags=["groups"], response_model=list[schemas.Group])
async def get_user_groups_list(current_user: schemas.User = Depends(dependencies.get_current_user),
                               db: AsyncSession = Depends(get_db)):
    groups = await crud.get_user_groups(db, current_user)

    return groups


@router.get("/groups/{group_id}/limits/", response_model=list[schemas.Limit])
async def get_group_limits_list(current_user: schemas.User = Depends(dependencies.get_current_user),
                                group_id: int = Path(title="The ID of the group to get"),
                                db: AsyncSession = Depends(get_db)):
    if not (group := await crud.get_group(db, group_id)):
        raise HTTPException(status_code=404, detail=f"Group doesn't exist")
    if current_user not in group.members and current_user.id != group.user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    limits = await crud.get_group_limits(db, group_id)

    return limits


@router.put("/groups/join/{group_code}/", tags=["groups"])
async def join_group(current_user: schemas.User = Depends(dependencies.get_current_user),
                     group_code: str = Path(title="Group code to join"),
                     db: AsyncSession = Depends(get_db)):
    if not (group := await crud.get_group_by_code(db, group_code)):
        raise HTTPException(status_code=404, detail=f"Group doesn't exist")
    
    if group.user_id == current_user.id:
        raise HTTPException(status_code=403, detail=f"You cannot join the group you own")
    
    if current_user in group.members:
        raise HTTPException(status_code=403, detail=f"You are already in this group")
    
    if await crud.add_to_group(db, group, current_user):
        return True
    raise HTTPException(status_code=500, detail="Error while joining group")


@router.put("/groups/{group_id}/", tags=["groups"])
async def update_group(group_data: schemas.GroupUpdate,
                       current_user: schemas.User = Depends(dependencies.get_current_user),
                       group_id: int = Path(title="The ID of the group to get"),
                       db: AsyncSession = Depends(get_db)):
    if not (group := await crud.get_group(db, group_id)):
        raise HTTPException(status_code=404, detail=f"Group doesn't exist")
    
    if group.user_id != current_user.id:
        raise HTTPException(status_code=403, detail=f"You don't own this group")
    
    group_code = None
    if group_data.refresh_code:
        group_code = strgen.StringGenerator("[\w\d]{6}").render()
        
    users = []
    if group_data.kick_users:
        users = await crud.get_users_list(db, group_data.kick_users, group.id)

    if updated_group := await crud.edit_group(db, group, schemas.GroupBase(
        name=group_data.name, 
        user_id=current_user.id
    ), group_code, users):
        return schemas.Group(
            id=updated_group.id,
            name=updated_group.name,
            user_id=updated_group.user_id,
            group_code=updated_group.group_code,
            author=schemas.User(
                email=updated_group.author.email,
                username=updated_group.author.username,
                id=updated_group.author.id
            ),
            categories=[
                schemas.Category(
                    category=category.category,
                    id=category.id,
                    user_id=category.user_id
                ) for category in updated_group.categories
            ],
            payments=[
                schemas.Payment(
                    id=payment.id,
                    name=payment.name,
                    type=payment.type,
                    category_id=payment.category_id,
                    user_id=payment.user_id,
                    cost=payment.cost,
                    payment_date=payment.payment_date,
                    payment_proof_id=payment.payment_proof_id,
                    renewable_id=payment.renewable_id,
                    category=schemas.Category(
                        category=payment.category.category,
                        id=payment.category.id,
                        user_id=payment.category.user_id
                    )
                ) for payment in updated_group.payments
            ],
            members=[
                schemas.User(
                    id=user.id,
                    username=user.username,
                    email=user.email
                ) for user in updated_group.members
            ]
        )
    raise HTTPException(status_code=500, detail=f"Error while updating group")


@router.delete("/groups/{group_id}/", tags=["groups"])
async def delete_group(current_user: schemas.User = Depends(dependencies.get_current_user),
                       group_id: int = Path(title="The ID of the group to get"),
                       db: AsyncSession = Depends(get_db)):
    if not (group := await crud.get_group(db, group_id)):
        raise HTTPException(status_code=404, detail=f"Group doesn't exist")
    
    if group.user_id != current_user.id:
        if current_user not in group.members:
            raise HTTPException(status_code=403, detail=f"You are already left this group")
        
        if await crud.remove_from_group(db, group, current_user):
            return True
        raise HTTPException(status_code=500, detail="Error while leaving group")
    
    if await crud.delete_group(db, group):
        return True

    raise HTTPException(status_code=500, detail="Error while deleting the group")