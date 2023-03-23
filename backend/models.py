import sqlalchemy as sa

from backend.database import Base


class User(Base):
    __tablename__ = "users"

    id = sa.Column(sa.Integer, primary_key=True, index=True)
    email = sa.Column(sa.String, unique=True, index=True)
    password_hash = sa.Column(sa.String)
    username = sa.Column(sa.String, unique=True, index=True)