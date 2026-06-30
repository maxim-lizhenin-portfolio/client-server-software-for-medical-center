from fastapi import APIRouter, Depends, HTTPException
from dependencies import open_csv_and_define_permission, decode_jwt, DEFAULT_DATABASE_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT
from typing import List
from pydantic import BaseModel
import psycopg2
import string
import random
import secrets
from passlib.hash import pbkdf2_sha256
router = APIRouter()


# ПОЛУЧЕНИЕ ИНФОРМАЦИИ О РАБОТНИКЕ
class EmployeeResponse(BaseModel):
	id:int
	surname: str
	name: str
	middle_name: str
	birth_date: str
	sex: bool
	passport_series: str
	passport_number: str
	passport_issued_whom: str
	passport_issued_when: str
	inn: str
	snils: str
	phone_number: str
	email: str
	post: str
	is_working:bool

@router.get("/employee/get", response_model=List[EmployeeResponse])
def get_data(token:str, ofsset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ",data)

	if not open_csv_and_define_permission(data["role"], "get_data"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
	dbname = DEFAULT_DATABASE_NAME,
		user = DB_USER,
		password = DB_PASSWORD,
		host = DB_HOST,
		port = DB_PORT
		) as conn:
		with conn.cursor() as cur:
			cur.execute("SELECT * FROM hired_employee")
			rows = cur.fetchall()
			print(rows)
			employees = [EmployeeResponse(id = r[0], surname = r[1], name = r[2], middle_name = r[3], birth_date = str(r[4]), sex = r[5],
										 passport_series = r[6], passport_number = r[7], passport_issued_whom = r[8], passport_issued_when = str(r[9]),
										 inn=r[10], snils=r[11], phone_number=r[12], email = r[13], post = r[14], is_working = r[18]) for r in rows]
			return employees



# ПОЛУЧЕНИЕ ИНФОРМАЦИИ <В КАКОЕ ОТДЕЛЕНИЕ И КОМНАТУ НАЗНАЧЕН РАБОТНИК>
class EmployeeInfoResponse(BaseModel):
	id:int
	surname: str
	name: str
	middle_name: str
	post: str
	department_name: str
	room_name: str

@router.get("/employee/get_post_info", response_model=List[EmployeeInfoResponse])
def get_employee_post_info(token:str, ofsset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ",data)

	if not open_csv_and_define_permission(data["role"], "get_employee_post_info"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
	dbname = DEFAULT_DATABASE_NAME,
		user = DB_USER,
		password = DB_PASSWORD,
		host = DB_HOST,
		port = DB_PORT
		) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT he.id_employee, he.surname, he.name, he.middle_name, he.post, COALESCE(dm.name, 'Не назначен'), COALESCE(rm.name, 'Не назначен')
						FROM hired_employee he
						LEFT JOIN employee_workplace ew ON he.id_employee = ew.id_employee
						LEFT JOIN department dm ON ew.id_department = dm.id_department
						LEFT JOIN room rm ON ew.id_room = rm.id_room
						WHERE he.is_working = true''')
			rows = cur.fetchall()
			print(rows)
			employees = [EmployeeInfoResponse(id = r[0], surname = r[1], name = r[2], middle_name = r[3], post = r[4], department_name = r[5], room_name = r[6]) for r in rows]
			return employees



# ДОБАВЛЕНИЕ РАБОТНИКА
class LoginRequest(BaseModel):
	username: str
	password: str

class EmployeeRequest(BaseModel):
	token:str
	surname: str
	name: str
	middle_name: str
	birth_date: str
	sex: bool
	passport_series: str
	passport_number: str
	passport_issued_whom: str
	passport_issued_when: str
	inn: str
	snils: str
	phone_number: str
	email: str
	post: str

@router.post("/employee/add", response_model=LoginRequest)
def add_employee(req:EmployeeRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "add_employee"):
		raise HTTPException(status_code=403, detail="Invalid role")
	with psycopg2.connect(
	dbname = DEFAULT_DATABASE_NAME,
		user = DB_USER,
		password = DB_PASSWORD,
		host = DB_HOST,
		port = DB_PORT
		) as conn:
		with conn.cursor() as cur:
			letters = string.ascii_letters
			new_username = ''.join(random.choice(letters) for i in range(10))
			cur.execute("SELECT * FROM hired_employee WHERE username = %s;", (new_username,))
			check_user = cur.fetchone()
			count = 10
			while check_user and count > 0:
				new_username = ''.join(random.choice(letters) for i in range(10))
				cur.execute("SELECT * FROM hired_employee WHERE username = %s;", (new_username,))
				check_user = cur.fetchone()
				count -= 1
			alphabet = string.ascii_letters + string.digits
			new_password = ''.join(secrets.choice(alphabet) for i in range(10))
			print("Логин:", new_username)
			print("Пароль:",new_password)
			password_hash = pbkdf2_sha256.hash(new_password)
			cur.execute('''
				INSERT INTO hired_employee(
				surname, name, middle_name, birth_date, sex, passport_series, passport_number,
				passport_issued_whom, passport_issued_when, inn, snils,phone_number, email, post, username, password_hash)
				VALUES
				(%s, %s, %s, %s, %s, %s, %s,
				%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id_employee;
			''', (req.surname, req.name, req.middle_name, req.birth_date, req.sex, req.passport_series, req.passport_number,
				req.passport_issued_whom, req.passport_issued_when, req.inn, req.snils,req.phone_number, req.email, req.post, new_username, password_hash))

			employee_id = cur.fetchone()[0]

			cur.execute("""
			            INSERT INTO employee_workplace (id_employee, id_department, id_room)
			            VALUES (%s, %s, %s)
			        """, (employee_id, None, None))  # или задайте значения по умолчанию

			conn.commit()
			return {"username":new_username, "password":new_password}



# УВОЛЬНЕНИЕ
class EmployeeDismissRequest(BaseModel):
	token:str
	id_employee:int

@router.post("/employee/dismiss")
def dismiss_employee(req:EmployeeDismissRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "dismiss_employee"):
		raise HTTPException(status_code=403, detail="Invalid role")
	with psycopg2.connect(
	dbname = DEFAULT_DATABASE_NAME,
		user = DB_USER,
		password = DB_PASSWORD,
		host = DB_HOST,
		port = DB_PORT
		) as conn:
		with conn.cursor() as cur:
			cur.execute('''
			UPDATE hired_employee SET is_working = %s WHERE id_employee = %s;
			''', (False, req.id_employee))
		conn.commit()
		return {"dismiss":"succesful"}
