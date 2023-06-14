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
    notifications_token = sa.Column(sa.String, nullable=True)

    categories = relationship("Category", back_populates="user", lazy='selectin')
    groups = relationship("Group", secondary='group_members', lazy='selectin')
    owned_groups = relationship("Group", back_populates='author', lazy='selectin')


class Category(Base):
    __tablename__ = "categories"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    category = sa.Column(sa.String, nullable=False)
    user_id = sa.Column(sa.Integer, sa.ForeignKey("users.id"))
    group_id = sa.Column(sa.Integer, sa.ForeignKey("groups.id"))

    user = relationship("User", back_populates="categories", lazy='selectin')
    group = relationship("Group", back_populates="categories", lazy='selectin')
    payments = relationship("Payment", back_populates="category", lazy='selectin')


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
    group_id = sa.Column(sa.Integer, sa.ForeignKey('groups.id'), nullable=True)
    cost = sa.Column(sa.Double, nullable=False)
    payment_date = sa.Column(sa.DateTime, nullable=False, default=datetime.utcnow(), server_default=sa.sql.func.now())
    payment_proof_id = sa.Column(sa.Integer, sa.ForeignKey("payment_proofs.id"), nullable=True)
    renewable_id = sa.Column(sa.Integer, sa.ForeignKey("renewables.id"), nullable=True)

    category = relationship("Category", back_populates="payments", lazy='selectin')
    payment_proof = relationship("PaymentProof", back_populates='payments', lazy='selectin')
    renewable = relationship("Renewable", back_populates='payments', lazy='selectin')


class PaymentProof(Base):
    __tablename__ = "payment_proofs"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    name = sa.Column(sa.String, nullable=False)
    filename = sa.Column(sa.String, nullable=False, index=True)
    url = sa.Column(sa.String, nullable=False)
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), nullable=False)
    group_id = sa.Column(sa.Integer, sa.ForeignKey('groups.id'), nullable=True)

    payments = relationship("Payment", back_populates='payment_proof', lazy='selectin')


class PeriodType(enum.Enum):
    YEARLY = "YEARLY"
    MONTHLY = "MONTHLY"
    WEEKLY = "WEEKLY"


class Renewable(Base):
    __tablename__ = "renewables"
    id = sa.Column(sa.Integer, primary_key=True, index=True)
    name = sa.Column(sa.String, nullable=False)
    type = sa.Column(sa.Enum(PaymentType), nullable=False)
    category_id = sa.Column(sa.Integer, sa.ForeignKey("categories.id"), nullable=True)
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), nullable=False)
    group_id = sa.Column(sa.Integer, sa.ForeignKey('groups.id'), nullable=True)
    cost = sa.Column(sa.Double, nullable=False)
    period = sa.Column(sa.Enum(PeriodType), nullable=False)
    payment_date = sa.Column(sa.DateTime, nullable=False, default=datetime.utcnow(), server_default=sa.sql.func.now())
    deleted_at = sa.Column(sa.DateTime, nullable=True)

    category = relationship("Category", back_populates=None, lazy='selectin')
    payments = relationship("Payment", back_populates='renewable', lazy='selectin')


class GroupMember(Base):
    __tablename__ = "group_members"
    group_id = sa.Column(sa.Integer, sa.ForeignKey("groups.id"), primary_key=True)
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), primary_key=True)


class Group(Base):
    __tablename__ = "groups"
    id = sa.Column(sa.Integer, primary_key=True, index=True)
    name = sa.Column(sa.String, nullable=False)
    group_code = sa.Column(sa.String, nullable=False)
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), nullable=False)

    author = relationship("User", back_populates="owned_groups", lazy='selectin')
    categories = relationship("Category", back_populates="group", lazy='selectin')
    payments = relationship("Payment", back_populates=None, lazy='selectin')
    members = relationship("User", secondary='group_members', lazy='selectin')

    def is_member(self, user: User):
        if user in self.members:
            return True
        elif user.id == self.user_id:
            return True
        return False


class LimitPeriod(enum.Enum):
    MONTHLY = "MONTHLY"
    WEEKLY = "WEEKLY"
    DAILY = "DAILY"


class Limit(Base):
    __tablename__ = "limits"
    id = sa.Column(sa.Integer, primary_key=True, index=True)
    value = sa.Column(sa.Double, nullable=False)
    period = sa.Column(sa.Enum(LimitPeriod), nullable=False, default="MONTHLY", server_default="MONTHLY")
    user_id = sa.Column(sa.Integer, sa.ForeignKey('users.id'), nullable=False)
    group_id = sa.Column(sa.Integer, sa.ForeignKey('groups.id'), nullable=True)
    is_active = sa.Column(sa.Boolean, nullable=False, default=True, server_default='true')
    n20_sent_at = sa.Column(sa.DateTime, nullable=True)
    n05_sent_at = sa.Column(sa.DateTime, nullable=True)
    nX_sent_at = sa.Column(sa.DateTime, nullable=True)