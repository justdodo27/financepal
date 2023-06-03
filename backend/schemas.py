from pydantic import BaseModel

from typing import Union
from datetime import datetime

from backend.models import PaymentType, PeriodType


class Token(BaseModel):
    access_token: str
    token_type: str

class UserBase(BaseModel): # base model
    email: str
    username: str

class UserCreate(UserBase): # used only to create the data
    password: str

class User(UserBase): # user only for reading the data
    id: int

    class Config:
        orm_mode = True # this allow the option to read the attribute by user.id instead of user["id"]

class CategoryBase(BaseModel):
    category: str

class CategoryCreate(CategoryBase):
    user_id: Union[int, None]

class Category(CategoryBase):
    id: int
    user_id: Union[int, None]

    class Config:
        orm_mode = True

class PaymentBase(BaseModel):
    name: str
    type: PaymentType
    category_id: Union[int, None]
    user_id: Union[int, None]
    cost: float
    payment_date: datetime
    payment_proof_id: Union[int, None]
    renewable_id: Union[int, None]

class Payment(PaymentBase):
    id: int
    category: Union[Category, None]

    class Config:
        orm_mode = True

class PaymentProofBase(BaseModel):
    filename: str
    url: str
    user_id: Union[int, None]

class PaymentProof(PaymentProofBase):
    id: int

    class Config:
        orm_moe = True

class PaymentWithProof(Payment):
    payment_proof: Union[PaymentProof, None]

class PaymentProofPayments(PaymentProof):
    payments: Union[list[Payment], None]

class RenewableBase(BaseModel):
    name: str
    type: PaymentType
    category_id: Union[int, None]
    user_id: Union[int, None]
    cost: float
    period: PeriodType
    payment_date: datetime

class RenewablePayment(BaseModel):
    cost: Union[float, None]
    payment_date: datetime

class Renewable(RenewableBase):
    id: int
    category: Union[Category, None]
    last_payment: Union[RenewablePayment, None]

    class Config:
        orm_mode = True

class GroupBase(BaseModel):
    name: str
    user_id: int

class GroupUpdate(GroupBase):
    kick_users: Union[list[int], None]
    refresh_code: bool

class Group(GroupBase):
    id: int
    group_code: str
    author: Union[User, None]
    categories: Union[list[Category], None]
    payments: Union[list[Payment], None]
    members: Union[list[User], None]

    class Config:
        orm_mode = True


class LimitBase(BaseModel):
    value: float
    user_id: int
    group_id: Union[int, None]
    category_id: Union[int, None]


class Limit(LimitBase):
    id: int
    category: Union[Category, None]