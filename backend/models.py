from tunetraderapp import db
from sqlalchemy.dialects.postgresql import JSON
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.dialects.postgresql import BYTEA
from sqlalchemy import func
#
from werkzeug.security import generate_password_hash, check_password_hash

class Song(db.Model):
    __tablename__="songs"
    id = db.Column(db.Integer,primary_key=True)
    symbol = db.Column(db.String,nullable=True)
    picture = db.Column(BYTEA)
    created = db.Column(db.DateTime,nullable=False,server_default=func.now())
    modified = db.Column(db.DateTime,nullable=False,server_default=func.now(), server_onupdate=func.now())

    def __init__(self, picture, symbol):
        self.picture = picture
        self.symbol = symbol

# class User(db.Model):
#     __tablename__="users"
#     id = db.Column(db.Integer,primary_key=True)
#
#     login = db.Column(db.String,nullable=False,unique=True)
#     password = db.Column(db.String(255), nullable=False)
#
#     def __init__ (self,login,password):
#         self.login = login
#         self.password = generate_password_hash(password,method='sha256')
#         print(login, self.password)
#
#     @classmethod
#     def authenticate(cls, **kwargs):
#         login = kwargs.get('login')
#         password = kwargs.get('password')
#
#         if not login or not password:
#             return None
#
#         user = cls.query.filter_by(login=login).first()
#         if not user or not check_password_hash(user.password,password):
#             return None
#
#         return user
#
#     def to_dict(self):
#         return dict(id=self.id, login=self.login)
