import sqlalchemy as sa
from sqlalchemy.orm import relationship

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