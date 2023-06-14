from random import randint, choice
from datetime import datetime

from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, schemas, models

def generate_payment_name(category: str):
    if category == 'Food':
        return choice(['Lidl groceries', 'Żabka', 'Duży Ben - libacja', 'Biedronka shopping', 'Zahir kebab - gastrofaza'])
    elif category == 'Fun':
        return choice(['Video game - Cyberpunk 2137', 'Tank model', 'Cheap stuff from China', 'Bowling', 'Dart', 'Paintball'])
    elif category == 'Bills':
        return choice(['Internet bill', 'Electric bill', 'Apartment bill', 'Gas bill', 'Water bill', 'Phone bill'])
    elif category == 'Others':
        return choice(['Top secret', 'Transaction', 'Bitcoin', 'New animal', 'Hitman', 'Car gasoline'])
    elif category == 'Clothes':
        return choice(['H&M', 'Pepco', 'Nike', 'Lumpex', 'Reserved', 'Supreme'])
    elif category == 'Protein':
        return choice(['KFD protein powder', 'Black market protein powder', 'Creatine'])
    elif category == 'Shoes':
        return choice(['Nike', 'Adidas', 'New Balance', 'Cheap shoes'])
    elif category == 'Travels':
        return choice(['Train ticket', 'Fly ticket to Venice', 'Fly ticket to Tokyo', 'Fly ticket to Oslo', 'Fly ticket to Warsaw'])

async def generate_dataset(db: AsyncSession):
    user1 = schemas.UserCreate(email="andrzej@gmail.com", username="endrju", password="Password123")
    u1 = await crud.create_user(db, user1)
    user2 = schemas.UserCreate(email="dominik@gmail.com", username="dodo", password="Password123")
    u2 = await crud.create_user(db, user2)
    user3 = schemas.UserCreate(email="kuba@gmail.com", username="syra", password="Password123")
    u3 = await crud.create_user(db, user3)

    c1 = await crud.create_category(db, schemas.CategoryCreate(category="Food", user_id=None))
    c2 = await crud.create_category(db, schemas.CategoryCreate(category="Fun", user_id=None))
    c3 = await crud.create_category(db, schemas.CategoryCreate(category="Bills", user_id=None))
    c4 = await crud.create_category(db, schemas.CategoryCreate(category="Others", user_id=None))
    c5 = await crud.create_category(db, schemas.CategoryCreate(category="Clothes", user_id=None))

    c1u1 = await crud.create_category(db, schemas.CategoryCreate(category="Protein", user_id=1))
    c2u1 = await crud.create_category(db, schemas.CategoryCreate(category="Shoes", user_id=1))
    c3u1 = await crud.create_category(db, schemas.CategoryCreate(category="Travels", user_id=1))
    
    await db.refresh(u1)
    await db.refresh(u2)
    await db.refresh(u3)
    await db.refresh(c1)
    await db.refresh(c2)
    await db.refresh(c3)
    await db.refresh(c4)
    await db.refresh(c5)

    for i in range(3):
        for user in [u1, u2, u3]:
            await db.refresh(user)
            for category in [c1, c2, c3, c4, c5]:
                await db.refresh(category)
                for payment_count in range(5):
                    await crud.create_payment(db, schemas.PaymentBase(
                        name=f"{generate_payment_name(category.category)} - {payment_count}",
                        type=schemas.PaymentType.BILL,
                        category_id=category.id,
                        user_id=user.id,
                        cost=randint(10, 1237) / randint(1, 10),
                        payment_date=datetime.utcnow().replace(tzinfo=None, day=randint(1, 20), month=datetime.utcnow().month-i)
                    ))
                    await db.refresh(user)
                await crud.create_payment(db, schemas.PaymentBase(
                        name=f"{generate_payment_name(category.category)} - TODAY",
                        type=schemas.PaymentType.BILL,
                        category_id=category.id,
                        user_id=user.id,
                        cost=randint(10, 500) / randint(1, 10),
                        payment_date=datetime.utcnow()
                    ))
                await db.refresh(user)
                
            if user.username == "endrju":
                await db.refresh(c1u1)
                await db.refresh(c2u1)
                await db.refresh(c3u1)
                pp = await crud.create_payment_proof(db, schemas.PaymentProofBase(
                    filename='paragon.png',
                    name="Paragon ;-)",
                    url='/app/backend/static/paragon.png',
                    user_id=user.id
                ))
                for category in [c1u1, c2u1, c3u1]:
                    await db.refresh(category)
                    for payment_count in range(10):
                        await crud.create_payment(db, schemas.PaymentBase(
                            name=f"{generate_payment_name(category.category)} - {payment_count}",
                            type=schemas.PaymentType.BILL,
                            category_id=category.id,
                            user_id=user.id,
                            cost=randint(10, 1237) / randint(1, 10),
                            payment_date=datetime.utcnow().replace(tzinfo=None, day=randint(1, 20), month=datetime.utcnow().month-i),
                            payment_proof_id=pp.id
                        ))
                        await db.refresh(user)
    
    return True