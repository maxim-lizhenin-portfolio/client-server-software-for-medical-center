from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
import secrets
import uvicorn
import psycopg2

from pydantic import BaseModel
import string
import random

from passlib.hash import pbkdf2_sha256
from typing import List
from routers import doctor, agent_num2, agent_num0, agent_num6

from dependencies import (
	DEFAULT_DATABASE_NAME, DEFAULT_PATH_PERMISSION_FILE, DEFAULT_TOKEN_LIFE_TIME,
decode_jwt, create_access_token, open_csv_and_define_permission,
DB_USER, DB_PASSWORD, DB_HOST, DB_PORT

)

app = FastAPI() # инициализация объекта для работы fastapi
app.include_router(doctor.router)
app.include_router(agent_num2.router)
app.include_router(agent_num0.router)
app.include_router(agent_num6.router)
tables = ["hired_employee", "work_shift", "employee_schedule", "hospital", "building", "department",
		  "room", "employee_workplace", "patient", "reception_schedule"]

roles	 = ["специалист по приему сотрудников", "составитель штатного расписания и структуры лечебного заведения",
		 "специалист по работе с клиентами", "врач", "медицинская сестра", "лаборант", "регистратор", "пациент", "повар", "admin"]


class LoginRequest(BaseModel):
	username: str
	password: str

class TokenResponse(BaseModel):
	access_token: str
	token_type: str



@app.post("/auth/login", response_model=TokenResponse)
def get_token(req:LoginRequest):
	with psycopg2.connect(
	dbname = DEFAULT_DATABASE_NAME,
		user = DB_USER,
		password = DB_PASSWORD,
		host = DB_HOST,
		port = DB_PORT
		) as conn:
		with conn.cursor() as cur:
			cur.execute("SELECT post, password_hash, is_working FROM hired_employee where username = %s;", (req.username,))
			post_and_hash = cur.fetchone()
			print(post_and_hash)

			if not post_and_hash or not pbkdf2_sha256.verify(req.password, post_and_hash[1]):
				raise HTTPException(status_code=401, detail="Invalid username or password")

			if not post_and_hash[2]:
				raise HTTPException(status_code=401, detail="Employee was fired")

			token = create_access_token({
				"sub": req.username,
				"role": post_and_hash[0]
			})
			return {"access_token": token, "token_type": "bearer"}


class HospitalResponse(BaseModel):
	id_hospital:int
	name:str
	date_foundation:str

@app.get("/hospital/get", response_model=List[HospitalResponse])
def get_hospital(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "get_hospital"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute("SELECT * FROM hospital")
			rows = cur.fetchall()
			print(rows)
			hospitals = [
				HospitalResponse(id_hospital=r[0], name=r[1], date_foundation=str(r[2]))
				for r in rows]
			return hospitals

class BuildingResponse(BaseModel):
	id_building:int
	id_hospital:int
	name:str
	date_foundation:str

@app.get("/building/get", response_model=List[BuildingResponse])
def get_building(token:str, id_hospital_for_search:int = -1, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "get_building"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			if id_hospital_for_search == -1:
				cur.execute("SELECT * FROM building")
			else:
				cur.execute("SELECT * FROM building WHERE id_hospital = %s", (id_hospital_for_search,))
			rows = cur.fetchall()
			print(rows)
			buildings = [
				BuildingResponse(id_building=r[0], id_hospital=r[1], name=r[2], date_foundation=str(r[3]))
				for r in rows]

			return buildings

class DepartmentResponse(BaseModel):
	id_department:int
	id_building:int
	name:str
	date_foundation:str

@app.get("/department/get", response_model=List[DepartmentResponse])
def get_department(token:str, id_building_for_search:int = -1, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "get_department"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			if id_building_for_search == -1:
				cur.execute("SELECT * FROM department")
			else:
				cur.execute("SELECT * FROM department WHERE id_building = %s", (id_building_for_search,))
			rows = cur.fetchall()
			print(rows)
			departments = [
				DepartmentResponse(id_department=r[0], id_building=r[1], name=r[2], date_foundation=str(r[3]))
				for r in rows]
			return departments

class RoomResponse(BaseModel):
	id_room:int
	id_department:int
	name:str

@app.get("/room/get", response_model=List[RoomResponse])
def get_room(token:str, id_department_for_search:int = -1, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "get_room"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			if id_department_for_search == -1:
				cur.execute("SELECT * FROM room")
			else:
				cur.execute("SELECT * FROM room WHERE id_department = %s", (id_department_for_search,))
			rows = cur.fetchall()
			print(rows)
			rooms = [
				RoomResponse(id_room=r[0], id_department=r[1], name=r[2])
				for r in rows]
			return rooms


class RoomEmployeeResponse(BaseModel):
	id_room:int
	id_department:int
	name:str
	count_employees:str

@app.get("/room/get_with_count", response_model=List[RoomEmployeeResponse])
def get_room_with_count(token:str, id_department_for_search:int = -1, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "get_room_with_count"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			# if id_department_for_search == -1:
			# 	cur.execute("SELECT * FROM room")
			# else:
			# 	cur.execute("SELECT * FROM room WHERE id_department = %s", (id_department_for_search,))
			# rows = cur.fetchall()
			# print(rows)
			# for row in rows:
			# 	cur.execute("SELECT COUNT(*) FROM employee_workplace WHERE id_room = %s", (row[0],))
			# 	cur.fetchone()
			# rooms = [
			# 	RoomEmployeeResponse(id_room=r[0], id_department=r[1], name=r[2])
			# 	for r in rows]
			cur.execute("""
			    SELECT r.*, COUNT(ew.id_workplace) as employee_count
			    FROM room r
			    LEFT JOIN employee_workplace ew ON r.id_room = ew.id_room
			    WHERE r.id_department = %s
			    GROUP BY r.id_room
			""", (id_department_for_search,))
			rows = cur.fetchall()
			print(rows)
			rooms = [
				RoomEmployeeResponse(id_room=r[0], id_department=r[1], name=r[2], count_employees = str(r[3]))
				for r in rows]
			return rooms

class HospitalAddRequest(BaseModel):
	token:str
	name:str
	data:str

@app.post("/hospital/add")
def add_hospital(req:HospitalAddRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "add_hospital"):
		raise HTTPException(status_code=403, detail="Invalid role")
	if req.name == "":
		raise HTTPException(status_code=401, detail="Invalid name")
	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute("INSERT into hospital (name, date_foundation) VALUES (%s, %s)", (req.name, req.data))
			conn.commit()
			return {"hospital/add": "succesful"}


class BuildingAddRequest(BaseModel):
	token:str
	id_hospital:int
	name:str
	data:str

@app.post("/building/add")
def add_building(req:BuildingAddRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "add_building"):
		raise HTTPException(status_code=403, detail="Invalid role")
	if req.name == "":
		raise HTTPException(status_code=401, detail="Invalid name")
	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute("INSERT into building (id_hospital, name, date_foundation) VALUES (%s, %s, %s)", (req.id_hospital, req.name, req.data))
			conn.commit()
			return {"building/add": "succesful"}


class DepartmentAddRequest(BaseModel):
	token: str
	id_building: int
	name: str
	data: str

@app.post("/department/add")
def add_department(req:DepartmentAddRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "add_department"):
		raise HTTPException(status_code=403, detail="Invalid role")
	if req.name == "":
		raise HTTPException(status_code=401, detail="Invalid name")
	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute("INSERT into department (id_building, name, date_foundation) VALUES (%s, %s, %s)", (req.id_building, req.name, req.data))
			conn.commit()
			return {"department/add": "succesful"}

class RoomAddRequest(BaseModel):
	token: str
	id_department: int
	name: str

@app.post("/room/add")
def add_room(req:RoomAddRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "add_room"):
		raise HTTPException(status_code=403, detail="Invalid role")
	if req.name == "":
		raise HTTPException(status_code=401, detail="Invalid name")
	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute("INSERT into room (id_department, name) VALUES (%s, %s)", (req.id_department, req.name))
			conn.commit()
			return {"room/add": "succesful"}


class SetWorkplaceDepartment(BaseModel):
	token: str
	id_employee: int
	id_department: int

class SetWorkplaceRoom(BaseModel):
	token: str
	id_employee: int
	id_room: int


@app.post("/employee/set_workplace_department")
def set_workplace_department(req:SetWorkplaceDepartment):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "set_workplace_department"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			id_value = None if req.id_department == -1 else req.id_department
			print(f'id_value is ', id_value)
			cur.execute('''
				UPDATE employee_workplace SET id_department = %s WHERE id_employee = %s;
				''', (id_value, req.id_employee))
			conn.commit()
			return {"employee/set_workplace_department": "succesful"}


@app.post("/employee/set_workplace_room")
def set_workplace_room(req:SetWorkplaceRoom):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "set_workplace_room"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			id_value = None if req.id_room == -1 else req.id_room
			print(f'id_value is ', id_value)
			cur.execute('''
				UPDATE employee_workplace SET id_room = %s WHERE id_employee = %s;
				''', (id_value, req.id_employee))
			conn.commit()
			return {"employee/set_workplace_room": "succesful"}

class EmployeeScheduleResponse(BaseModel):
	id_schedule: int
	work_date: str
	start_time: str
	end_time: str
	break_duration: str
	reception_count: str


@app.get("/employee_schedule/get_info_with_id", response_model=List[EmployeeScheduleResponse])
def employee_schedule_get_info_with_id(token:str, id_employee:int, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "employee_schedule_get_info_with_id"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''
				SELECT es.id_schedule, es.work_date, ws.start_time, ws.end_time, ws.break_duration, 0 as reception_count
				FROM employee_schedule es
				LEFT JOIN work_shift ws ON es.id_work = ws.id_work

				WHERE id_employee = %s
				ORDER BY es.work_date

			''', (id_employee,))

			# cur.execute('''
			# 				SELECT es.work_date, ws.start_time, ws.end_time, ws.break_duration, COALESCE(rs.reception_count, 0) as reception_count
			# 				FROM employee_schedule es
			# 				LEFT JOIN work_shift ws ON es.id_work = ws.id_work
			# 				LEFT JOIN(
			# 					SELECT
			# 						id_employee,
			# 						reception_date,
			# 						COUNT(*) as reception_count
			# 					FROM reception_schedule
			# 					WHERE reception_schedule.id_employee = %s
			# 					GROUP BY reception_schedule.id_employee, reception_date
			# 				) rs ON es.id_employee = rs.id_employee and es.work_date = rs.reception_date
			# 				WHERE rs.id_employee = %s
			# 				ORDER BY es.work_date
			#
			# 			''', (id_employee, id_employee))

			rows = cur.fetchall()
			print(rows)
			Employeeschedule = [
				EmployeeScheduleResponse(id_schedule=r[0], work_date=str(r[1]), start_time=str(r[2]), end_time=str(r[3]), break_duration=str(r[4]), reception_count = str(r[5]))
				for r in rows]

			return Employeeschedule

class ScheduleAddDay(BaseModel):
	token: str
	id_employee: int
	id_work: int
	work_date: str
	work_note: str


@app.post("/employee_schedule/add_work_day")
def employee_schedule_add_work_day(req: ScheduleAddDay):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "employee_schedule_add_work_day"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			print(req.id_employee, req.id_work, req.work_date, req.work_note)

			cur.execute("INSERT into employee_schedule (id_employee, id_work, work_date, work_note) VALUES (%s, %s, %s, %s)",
						(req.id_employee, req.id_work, req.work_date, req.work_note))
			conn.commit()
			return {"employee_schedule/add_work_day": "succesful"}

# Класс для json-ответа
class WorkShiftResponse(BaseModel):
	id_work: int
	work_type: str
	start_time: str
	end_time: str
	break_duration: str
# Получение расписания работы для определенного сотрудника по его id
@app.get("/work_shift/get", response_model=List[WorkShiftResponse])
def work_shift_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "work_shift_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT * FROM work_shift''')
			rows = cur.fetchall()
			print(rows)
			workshift = [
				WorkShiftResponse(id_work=r[0], work_type=r[1], start_time=str(r[2]),
										 end_time=str(r[3]), break_duration=str(r[4]))
				for r in rows]

			return workshift



#Второе окно STATE2

# Класс для json-ответа
class ReceptionSheduleResponse(BaseModel):
	reception_type: str
	start_time: str
	end_time: str
	surname: str
	name: str
	middle_name:str
	reception_note: str
	status: str

# Получение записей приёмов на текущий рабочий день одного сотрудника
@app.get("/reception_schedule/get", response_model=List[ReceptionSheduleResponse])
def reception_schedule_get(token:str, id_employee:int, reception_date:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "reception_schedule_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT rs.reception_type, rs.start_time, rs.end_time, p.surname, p.name, p.middle_name, 
							rs.reception_note, rs.status
			 				FROM reception_schedule rs
			 				LEFT JOIN patient p ON p.id_patient = rs.id_patient
			 				WHERE id_employee = %s AND rs.reception_date = %s
			 						 				
			 				''', (id_employee, reception_date))
			rows = cur.fetchall()

			print(rows)
			reception = [
				ReceptionSheduleResponse(reception_type = r[0], start_time = str(r[1]), end_time = str(r[2]),
	surname = r[3], name = r[4], middle_name = r[5], reception_note = r[6], status = r[7])
				for r in rows]
			return reception



class ReceptionAdd(BaseModel):
	token: str
	id_employee: int
	reception_type: str
	reception_date: str
	start_time: str
	end_time: str
	id_patient: int
	reception_note: str
	status: str


@app.post("/reception_schedule/add_reception")
def employee_schedule_add_reception(req: ReceptionAdd):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "employee_schedule_add_reception"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			print(req.id_employee, req.reception_type, req.reception_date, req.start_time,
						 req.end_time, req.id_patient, req.reception_note, req.status)
			cur.execute('''INSERT into reception_schedule (id_employee, reception_type, reception_date, start_time, end_time,
			id_patient, reception_note, status		
			) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)''',
						(req.id_employee, req.reception_type, req.reception_date, req.start_time,
						 req.end_time, req.id_patient, req.reception_note, req.status))
			conn.commit()
			return {"reception_schedule/add_reception": "succesful"}


class AddMenuRequest(BaseModel):
	token: str
	menu_text: str

@app.post("/menu/add")
def menu_add(req: AddMenuRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "menu_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''INSERT into menu (menu_text) VALUES (%s)''', (req.menu_text,))
		conn.commit()
		return {"menu/add": "succesful"}


if __name__ == "__main__":
	uvicorn.run("main:app", reload = True) # запуск локального сервера с fastapi документацией