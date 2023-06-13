from pydantic import BaseModel
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.param_functions import Form

from typing import Union, Optional
from datetime import datetime

from backend.models import PaymentType, PeriodType, LimitPeriod

class AuthorizationModel(OAuth2PasswordRequestForm):
    def __init__(
        self,
        grant_type: str = Form(default=None, regex="password"),
        username: str = Form(),
        password: str = Form(),
        token: Optional[str] = Form(),
        scope: str = Form(default=""),
        client_id: Optional[str] = Form(default=None),
        client_secret: Optional[str] = Form(default=None),
    ):
        self.grant_type = grant_type
        self.username = username
        self.password = password
        self.token = token
        self.scopes = scope.split()
        self.client_id = client_id
        self.client_secret = client_secret


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
    group_id: Union[int, None]


class Category(CategoryBase):
    id: int
    user_id: Union[int, None]
    group_id: Union[int, None]

    class Config:
        orm_mode = True


class PaymentBase(BaseModel):
    name: str
    type: PaymentType
    category_id: Union[int, None]
    user_id: Union[int, None]
    group_id: Union[int, None]
    cost: float
    payment_date: datetime
    payment_proof_id: Union[int, None]
    renewable_id: Union[int, None]


class Payment(PaymentBase):
    id: int
    category: Union[Category, None]

    class Config:
        orm_mode = True


class PaymentProofCreate(BaseModel):
    name: str

    class Config:
        orm_moe = True


class PaymentProofBase(BaseModel):
    filename: str
    name: str
    url: str
    user_id: Union[int, None]
    group_id: Union[int, None]

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
    group_id: Union[int, None]
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
    is_active: bool
    group_id: Union[int, None]
    period: LimitPeriod


class Limit(LimitBase):
    id: int


class PieChartRecord(BaseModel):
    category_id: int
    category: str
    percentage: float
    value: float


class LineChartRecord(BaseModel):
    x_data: str
    y_data: str


class CategoryAggregated(BaseModel):
    category_id: int
    name: str
    value: float
    count: int


class Statistic(BaseModel):
    pie_chart_data: Union[list[PieChartRecord], None]
    plot_data: Union[list[LineChartRecord], None]
    payments_list: Union[list[CategoryAggregated], None]

    class Config:
        orm_mode = True