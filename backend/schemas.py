from pydantic import BaseModel
from typing import Union


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

class CategoryQuery(BaseModel):
    user_id: Union[int, None]
    # group_id: Union[int, None]