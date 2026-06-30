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

class AllRoomResponse(BaseModel):
	id_room: int
	room_name: str
	department_name: str
	building_name: str
	hospital_name: str

@router.get("/room/get_all", response_model=List[AllRoomResponse])
def room_get_all(token:str, offset:int = 0, limit:int = 100):
	data = decode_jwt(token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "room_get_all"):
		raise HTTPException(status_code=403, detail="Invalid role")

	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur.execute('''SELECT r.id_room, r.name, d.name, b.name, h.name FROM room r
						LEFT JOIN department d ON r.id_department = d.id_department
						LEFT JOIN building b ON b.id_building = d.id_building
						LEFT JOIN hospital h ON h.id_hospital = b.id_hospital
						ORDER BY r.id_room ASC
						''')
			rows = cur.fetchall()
			print(rows)
			allrooms = [
				AllRoomResponse(id_room=r[0], room_name=r[1], department_name=r[2], building_name = r[3], hospital_name = r[4])
				for r in rows]
			return allrooms


class PatientRoomUpdateRequest(BaseModel):
	token:str
	id_patient:int
	id_room:str

@router.post("/patient/update_room")
def patient_update_room(req:PatientRoomUpdateRequest):
	data = decode_jwt(req.token)
	print("decode_jwt ", data)

	if not open_csv_and_define_permission(data["role"], "patient_update_room"):
		raise HTTPException(status_code=403, detail="Invalid role")
	with psycopg2.connect(
			dbname=DEFAULT_DATABASE_NAME,
			user=DB_USER,
			password=DB_PASSWORD,
			host=DB_HOST,
			port=DB_PORT
	) as conn:
		with conn.cursor() as cur:
			cur_id_room = ""
			cur_in_hospital = ""
			if req.id_room == "None":
				cur_id_room = None
				cur_in_hospital = False
			else:
				cur_id_room = int(req.id_room)
				cur_in_hospital = True


			print(cur_id_room)
			cur.execute("UPDATE patient SET id_room = %s, in_hospital = %s WHERE id_patient = %s;", (cur_id_room, cur_in_hospital, req.id_patient))
			conn.commit()
			return {"patient/update_room": "succesful"}