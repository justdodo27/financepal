import sqlalchemy as sa
from sqlalchemy.orm import relationship

from datetime import datetime
import enum

from backend.database import Base


class User(Base):
    __tablename__ = "users"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    email = sa.Column(sa.String, unique=True, nullable=False, index=True)
    password_hash = sa.Column(sa.String, nullable=False)
    username = sa.Column(sa.String, unique=True, nullable=False, index=True)

    categories = relationship("Category", back_populates="user")


class Category(Base):
    __tablename__ = "categories"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    category = sa.Column(sa.String, nullable=False)
    user_id = sa.Column(sa.Integer, sa.ForeignKey("users.id"))
    # group_id = TODO syra dodaj tu relacje do groups XD

    user = relationship("User", back_populates="categories")
    payments = relationship("Payment", back_populates="category")


class PaymentType(enum.Enum):
    BILL = "BILL" # rachunek
    INVOICE = "INVOICE" #faktura
    SUBSCRIPTION = "SUBSCRIPTION" # subskrybcja


class Payment(Base):
    __tablename__ = "payments"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    name = sa.Column(sa.String, nullable=False)
    type = sa.Column(sa.Enum(PaymentType), nullable=False)
    category_id = sa.Column(sa.Integer, sa.ForeignKey("categories.id"), nullable=True)
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), nullable=False)
    cost = sa.Column(sa.Double, nullable=False)
    payment_date = sa.Column(sa.DateTime, nullable=False, default=datetime.utcnow(), server_default=sa.sql.func.now())
    # payment_proof_id = sa.Column(sa.Integer, sa.ForeignKey("payment_proofs.id"), nullable=True)

    category = relationship("Category", back_populates="payments", lazy='selectin')