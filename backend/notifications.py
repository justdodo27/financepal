import datetime
from typing import Union

from backend import crud, models

from sqlalchemy.ext.asyncio import AsyncSession
from firebase_admin import messaging

def send_notification(registration_token: str, title: str, body: str):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        android=messaging.AndroidConfig(
            ttl=datetime.timedelta(seconds=3600),
            priority='normal',
            notification=messaging.AndroidNotification(
                icon='stock_ticker_update',
                color='#f45342'
            ),
        ),
        token=registration_token
    )

    response = messaging.send(message)

    print("Successfully sent message:", message)


async def check_notifications(db: AsyncSession, user_id: models.User, group_id: Union[int, None]):
    user = await crud.get_user(db, user_id=user_id)
    limits = await crud.check_limit(db, user_id=user.id, group_id=group_id)
    
    if not user.notifications_token: return
    for limit in limits:
        if limit.percentage > 0.8 and limit.percentage < 0.95 and (not limit.n20_sent_at or limit.n20_sent_at.month != datetime.datetime.utcnow().month):
            print('0.8-0.95')
            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} limit status", 
                              body=f"{user.username} your {limit.period} limit is at {round(limit.percentage*100)}% 👀")
            limit_update = await crud.get_limit(db, limit_id=limit.id)
            await crud.update_limits_sents(db, limit=limit_update, sent_type='n20')
        elif limit.percentage > 0.95 and limit.percentage < 1.0 and (not limit.n05_sent_at or limit.n05_sent_at.month != datetime.datetime.utcnow().month):
            print('0.95-1.0')

            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} almost reached the limit", 
                              body=f"{user.username} your {limit.period} limit is at {round(limit.percentage*100)}% 🥵")
            limit_update = await crud.get_limit(db, limit_id=limit.id)
            await crud.update_limits_sents(db, limit=limit_update, sent_type='n05')
        elif limit.percentage > 1.0 and (not limit.nX_sent_at or limit.nX_sent_at.month != datetime.datetime.utcnow().month):
            print('1.0+')
            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} limit exceeded", 
                              body=f"{user.username} you've exceeded your {limit.period} limit 😳")
            limit_update = await crud.get_limit(db, limit_id=limit.id)
            await crud.update_limits_sents(db, limit=limit_update, sent_type='nX')
            

async def test_notification(db: AsyncSession, user_id: models.User):
    user = await crud.get_user(db, user_id=user_id)

    if not user.notifications_token: return

    send_notification(registration_token=user.notifications_token,
                      title=f"{user.email} this is your test notification",
                      body=f"Some weird message 👀2️⃣1️⃣3️⃣7️⃣ 🔥🔥🔥")