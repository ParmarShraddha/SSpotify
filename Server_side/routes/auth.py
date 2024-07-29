import uuid
import bcrypt
from fastapi import APIRouter, HTTPException
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from fastapi import Depends
from database import get_db
from pydantic_schemas.user_login import UserLogin
import jwt

router = APIRouter()
@router.post("/signup",status_code=201)
def signup_user(user:UserCreate, db:Session = Depends(get_db)):  
    #check if user already exist in db
    user_db = db.query(User).filter(User.email == user.email).first()
   
    if user_db:
        print(f"User with email {user.email} already exists.")
        raise HTTPException(400,'User with the same email already exist !!')
           
    hased_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db = User(id= str(uuid.uuid4()), email= user.email, password=hased_pw, name=user.name)
    
    #add the user to the db
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    #check if user exist!!
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, "USer does not exist!")
    
    #password matching or not
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)
    
    if not is_match:
        raise HTTPException(400, "incorrect Password!")
    
    token =  jwt.encode({'id': user_db.id }, "password_key")
    
    return {'token': token,'user':user_db}