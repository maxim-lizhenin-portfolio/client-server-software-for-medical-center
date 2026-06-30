from fastapi import APIRouter, Depends, HTTPException
from dependencies import open_csv_and_define_permission, decode_jwt, DEFAULT_DATABASE_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT
from typing import List
from pydantic import BaseModel
import psycopg2

router = APIRouter()




# Класс для json-ответа
class PatientResponse(BaseModel):
	surname: str
	name: str
	middle_name: str
	date_of_birth: str
	sex: str
	id_patient: str
	in_hospital:str



# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/patient/get", response_model=List[PatientResponse])
def patient_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "patient_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT p.surname, p.name, p.middle_name, p.date_of_birth, p.sex, p.id_patient, p.in_hospital
			FROM patient p''')
			rows = cur.fetchall()

			print(rows)
			patient = [
				PatientResponse(surname=r[0], name=r[1], middle_name=r[2],
								date_of_birth=str(r[3]),
								sex= "мужской" if bool(r[4]) else "женский",
								id_patient=str(r[5]),
								in_hospital= "в стационаре" if r[6] else "амбулаторно")
				for r in rows]
			return patient

# MEDICAL
# Класс для json-ответа
class MedicalResponse(BaseModel):
	surname: str
	name: str
	middle_name: str
	medical_date: str
	medical_time: str
	medical_text: str

# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/medical/get", response_model=List[MedicalResponse])
def medical_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "medical_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT he.surname, he.name, he.middle_name, m.medical_date, m.medical_time, m.medical_text
						FROM medical m LEFT JOIN hired_employee he ON he.id_employee = m.id_employee''')
			rows = cur.fetchall()

			print(rows)
			medical = [
				MedicalResponse(surname=r[0], name=r[1], middle_name=r[2],
								medical_date = str(r[3]), medical_time = str(r[4]), medical_text=r[5])
				for r in rows]
			return medical


class MedicalAdd(BaseModel):
	token: str
	id_patient: int
	medical_text: str


@router.post("/medical/add")
def medical_add(req: MedicalAdd):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "medical_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute(
				'''
				INSERT INTO medical (id_patient, id_employee, medical_text)
				SELECT %s, he.id_employee, %s
				FROM hired_employee he
				WHERE he.username = %s
				''',
				(req.id_patient, req.medical_text, data["sub"])
			)
			conn.commit()
			return {"medical/add": "succesful"}


# ANALYSIS
# Класс для json-ответа
class AnalysisResponse(BaseModel):
	surname: str
	name: str
	middle_name: str
	analysis_date: str
	analysis_time: str
	analysis_text: str

# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/analysis/get", response_model=List[AnalysisResponse])
def analysis_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "analysis_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT he.surname, he.name, he.middle_name, a.analysis_date, a.analysis_time, a.analysis_text
						FROM analysis a LEFT JOIN hired_employee he ON he.id_employee = a.id_employee''')
			rows = cur.fetchall()

			print(rows)
			analysis = [
				AnalysisResponse(surname=r[0], name=r[1], middle_name=r[2],
								analysis_date = str(r[3]), analysis_time = str(r[4]), analysis_text=r[5])
				for r in rows]
			return analysis


class AnalysisAdd(BaseModel):
	token: str
	id_patient: int
	analysis_text: str


@router.post("/analysis/add")
def analysis_add(req: AnalysisAdd):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "analysis_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute(
				'''
				INSERT INTO analysis (id_patient, id_employee, analysis_text)
				SELECT %s, he.id_employee, %s
				FROM hired_employee he
				WHERE he.username = %s
				''',
				(req.id_patient, req.analysis_text, data["sub"])
			)
			conn.commit()
			return {"analysis/add": "succesful"}


# SESSION
class SessionResponse(BaseModel):
	surname: str
	name: str
	middle_name: str
	session_date: str
	session_time: str
	session_text: str

# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/session/get", response_model=List[SessionResponse])
def session_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "session_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT he.surname, he.name, he.middle_name, s.session_date, s.session_time, s.session_text
						FROM session s LEFT JOIN hired_employee he ON he.id_employee = s.id_employee''')
			rows = cur.fetchall()

			print(rows)
			session = [
				SessionResponse(surname=r[0], name=r[1], middle_name=r[2],
								session_date = str(r[3]), session_time = str(r[4]), session_text=r[5])
				for r in rows]
			return session


class SessionAdd(BaseModel):
	token: str
	id_patient: int
	session_text: str


@router.post("/session/add")
def session_add(req: SessionAdd):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "session_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute(
				'''
				INSERT INTO session (id_patient, id_employee, session_text)
				SELECT %s, he.id_employee, %s
				FROM hired_employee he
				WHERE he.username = %s
				''',
				(req.id_patient, req.session_text, data["sub"])
			)
			conn.commit()
			return {"session/add": "succesful"}
		


# APPOINTMENT
class AppointmentResponse(BaseModel):
	surname: str
	name: str
	middle_name: str
	appointment_date: str
	appointment_time: str
	appointment_text: str

# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/appointment/get", response_model=List[AppointmentResponse])
def appointment_get(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "appointment_get"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT he.surname, he.name, he.middle_name, ap.appointment_date, ap.appointment_time, ap.appointment_text
						FROM appointment ap LEFT JOIN hired_employee he ON he.id_employee = ap.id_employee''')
			rows = cur.fetchall()

			print(rows)
			appointment = [
				AppointmentResponse(surname=r[0], name=r[1], middle_name=r[2],
								appointment_date = str(r[3]), appointment_time = str(r[4]), appointment_text=r[5])
				for r in rows]
			return appointment


class AppointmentAdd(BaseModel):
	token: str
	id_patient: int
	appointment_text: str


@router.post("/appointment/add")
def appointment_add(req: AppointmentAdd):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "appointment_add"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute(
				'''
				INSERT INTO appointment (id_patient, id_employee, appointment_text)
				SELECT %s, he.id_employee, %s
				FROM hired_employee he
				WHERE he.username = %s
				''',
				(req.id_patient, req.appointment_text, data["sub"])
			)
			conn.commit()
			return {"appointment/add": "succesful"}


# STATE1
class EmployeeScheduleResponse(BaseModel):
	id_schedule: int
	work_date: str
	start_time: str
	end_time: str
	break_duration: str
	reception_count: str

@router.get("/employee_schedule/get_info_by_current_username", response_model=List[EmployeeScheduleResponse])
def employee_schedule_get_info_by_current_username(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "employee_schedule_get_info_by_current_username"):
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

				WHERE id_employee = (SELECT id_employee FROM hired_employee WHERE username = %s)
				ORDER BY es.work_date

			''', (data["sub"],))
			rows = cur.fetchall()
			print(rows)
			Employeeschedule = [
				EmployeeScheduleResponse(id_schedule=r[0], work_date=str(r[1]), start_time=str(r[2]),
										 end_time=str(r[3]), break_duration=str(r[4]), reception_count=str(r[5]))
				for r in rows]

			return Employeeschedule


# Класс для json-ответа
class ReceptionSheduleResponse(BaseModel):
	reception_type: str
	start_time: str
	end_time: str
	surname: str
	name: str
	middle_name: str
	reception_note: str
	status: str
	id_reception_schedule: int


# Получение записей приёмов на текущий рабочий день одного сотрудника
@router.get("/reception_schedule/get_by_current_username", response_model=List[ReceptionSheduleResponse])
def reception_schedule_get_by_current_username(token: str, reception_date: str, offset: int = 0, limit: int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "reception_schedule_get_by_current_username"):
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
							rs.reception_note, rs.status, rs.id_reception_schedule
			 				FROM reception_schedule rs
			 				LEFT JOIN patient p ON p.id_patient = rs.id_patient
			 				WHERE id_employee = (SELECT id_employee FROM hired_employee WHERE username = %s) AND rs.reception_date = %s
							ORDER BY rs.id_reception_schedule
			 				''', (data["sub"], reception_date))
			rows = cur.fetchall()

			print(rows)
			reception = [
				ReceptionSheduleResponse(reception_type=r[0], start_time=str(r[1]), end_time=str(r[2]),
										 surname=r[3], name=r[4], middle_name=r[5], reception_note=r[6], status=r[7], id_reception_schedule = r[8])
				for r in rows]
			return reception


class ReceptionStatusUpdate(BaseModel):
	token: str
	id_reception_schedule: int
	status: str

@router.post("/reception_schedule/update_status")
def reception_schedule_update_status(req: ReceptionStatusUpdate):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)
	if not open_csv_and_define_permission(data["role"], "reception_schedule_update_status"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			print("Текущий id = ", req.id_reception_schedule)
			cur.execute('''UPDATE reception_schedule SET status = %s WHERE id_reception_schedule = %s''',
						(req.status, req.id_reception_schedule))
			conn.commit()
			return {"update_status": "succesful"}