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


class PatientRequest(BaseModel):
	token:str
	surname: str
	name: str
	middle_name: str
	date_of_birth: str
	sex: bool
	passport_series: str
	passport_number: str
	passport_issued_whom: str
	passport_issued_when: str
	snils: str
	polis: str
	phone_number: str
	email: str
	in_hospital: str

@router.post("/patient/add")
def patient_add(req:PatientRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "patient_add"):
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
			cur.execute("SELECT * FROM patient WHERE username = %s;", (new_username,))
			check_user = cur.fetchone()
			count = 10
			while check_user and count > 0:
				new_username = ''.join(random.choice(letters) for i in range(10))
				cur.execute("SELECT * FROM patient WHERE username = %s;", (new_username,))
				check_user = cur.fetchone()
				count -= 1
			alphabet = string.ascii_letters + string.digits
			new_password = ''.join(secrets.choice(alphabet) for i in range(10))
			print("Логин:", new_username)
			print("Пароль:",new_password)
			password_hash = pbkdf2_sha256.hash(new_password)


			if req.in_hospital == "амбулаторно":
				cur_in_hospital = False
			else:
				cur_in_hospital = True
			cur.execute('''
				INSERT INTO patient(
				surname, name, middle_name, date_of_birth, sex, passport_series, passport_number,
				passport_issued_whom, passport_issued_when, snils, polis, phone_number, email, username, password_hash, 
				in_hospital)
				VALUES
				(%s, %s, %s, %s, %s, %s, %s,
				%s, %s, %s, %s, %s, %s, %s, %s, %s);
			''', (req.surname, req.name, req.middle_name, req.date_of_birth, req.sex, req.passport_series, req.passport_number,
				req.passport_issued_whom, req.passport_issued_when, req.snils, req.polis, req.phone_number, req.email, new_username, password_hash,
				  cur_in_hospital))
			conn.commit()
			return {"username":new_username, "password":new_password}

class PolisRequest(BaseModel):
	token: str
	id_patient: int
	polis: str

@router.post("/patient/check_polis")
def patient_check_polis(req:PolisRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "patient_check_polis"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT p.polis FROM patient p WHERE p.id_patient = %s''', (req.id_patient,))
			polis = cur.fetchone()[0]

			response = ""
			if polis == req.polis:
				response = "Valid"
			else:
				response = "Not valid"
			rows = cur.fetchall()
			print(rows)

			return {"result": response}


class SnilsPolisResponse(BaseModel):
	snils: str
	polis: str


@router.get("/patient/get_snils_polis", response_model=List[SnilsPolisResponse])
def patient_get_snils_polis(token:str, id_patient:int, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "patient_get_snils_polis"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT p.snils, p.polis FROM patient p WHERE p.id_patient = %s''', (id_patient,))
			rows = cur.fetchall()
			print(rows)
			snilspolis = [
				SnilsPolisResponse(snils=r[0], polis=r[1])
				for r in rows]
			return snilspolis



class SetHospitalRequest(BaseModel):
	token: str
	id_patient: int
	id_hospital: str

@router.post("/patient/set_hospital")
def patient_set_hospital(req:SetHospitalRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "patient_set_hospital"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:

			cur_id_hospital = ""
			if req.id_hospital == "None":
				cur_id_hospital = None
			else:
				cur_id_hospital = int(float(req.id_hospital))

			cur.execute('''UPDATE patient SET id_hospital = %s WHERE id_patient = %s;''', (cur_id_hospital, req.id_patient))
			conn.commit()
			return {"patient/set_hospital": "succesful"}


class CreatePaymentRequest(BaseModel):
	token: str
	id_patient: int
	id_session: int
	payment_amount: int

@router.post("/payment/add")
def payment_add(req:CreatePaymentRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "payment_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''INSERT into payment (id_patient, id_session, payment_amount) VALUES (%s, %s, %s)''',
						(req.id_patient, req.id_session, req.payment_amount))
			conn.commit()
			return {"payment/add": "succesful"}