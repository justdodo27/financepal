from pydantic import BaseModel


class UserBase(BaseModel): # base model
    email: str
    username: str


class UserCreate(UserBase): # used only to create the data
    password: str


class User(UserBase): # user only for reading the data
    id: int

    class Config:
        orm_mode = True # this allow the option to read the attribute by user.id instead of user["id"]