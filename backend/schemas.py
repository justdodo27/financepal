from pydantic import BaseModel

from typing import Union
from datetime import datetime

from backend.models import PaymentType


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
    # payment_proof_id: int

class Payment(PaymentBase):
    id: int
    category: Union[Category, None]

    class Config:
        orm_mode = True