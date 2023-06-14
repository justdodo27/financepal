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
        if limit.percentage > 0.8 and limit.percentage < 0.95 and limit.n20_sent_at.month != datetime.date.month:
            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} limit status", 
                              body=f"{user.username} your limit for {limit.period} is at {round(limit.percentage*100, 2)}% ({limit.payments_sum}).")
        elif limit.percentage > 0.95 and limit.percentage < 1.0 and limit.n05_sent_at.month != datetime.date.month:
            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} almost reached the limit", 
                              body=f"{user.username} you've almost exceeded your limit for {limit.period}. Limit is at {round(limit.percentage*100, 2)}% ({limit.payments_sum}).")
        elif limit.percentage > 1.0 and limit.nX_sent_at.month != datetime.date.month:
            send_notification(registration_token=user.notifications_token, 
                              title=f"{limit.period} limit exceeded", 
                              body=f"{user.username} you've exceeded your limit for {limit.period}. Limit is at {round(limit.percentage*100, 2)}% ({limit.payments_sum}).")
            

async def test_notification(db: AsyncSession, user_id: models.User):
    user = await crud.get_user(db, user_id=user_id)

    if not user.notifications_token: return

    send_notification(registration_token=user.notifications_token,
                      title=f"{user.email} this is your test notification",
                      body=f"Some weird message 👀2️⃣1️⃣3️⃣7️⃣ 🔥🔥🔥")