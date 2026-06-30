import psycopg2
from passlib.hash import pbkdf2_sha256
from dependencies import DB_USER, DB_PASSWORD, DB_HOST, DB_PORT

DEFAULT_DATABASE_NAME = 'medical_institution_coursework_db'

def create_db():
	with psycopg2.connect(
		dbname = DEFAULT_DATABASE_NAME,
			user = DB_USER,
			password = DB_PASSWORD,
			host = DB_HOST,
			port = DB_PORT
			) as conn:
			with conn.cursor() as cur:
				cur.execute('DROP TABLE IF EXISTS medical;')
				cur.execute('DROP TABLE IF EXISTS analysis;')
				cur.execute('DROP TABLE IF EXISTS session;')
				cur.execute('DROP TABLE IF EXISTS appointment;')
				cur.execute('DROP TABLE IF EXISTS payment;')
				cur.execute('DROP TABLE IF EXISTS employee_schedule;')
				cur.execute('DROP TABLE IF EXISTS employee_workplace;')
				cur.execute('DROP TABLE IF EXISTS reception_schedule;')
				cur.execute('DROP TABLE IF EXISTS reception_shift;')
				cur.execute('DROP TABLE IF EXISTS patient;')
				cur.execute('DROP TABLE IF EXISTS room;')
				cur.execute('DROP TABLE IF EXISTS department;')
				cur.execute('DROP TABLE IF EXISTS building;')
				cur.execute('DROP TABLE IF EXISTS hospital;')
				cur.execute('DROP TABLE IF EXISTS hired_employee;')
				cur.execute('DROP TABLE IF EXISTS work_shift;')


				conn.commit()


				#Таблица нанятых рабочих
				cur.execute('''
					CREATE TABLE IF NOT EXISTS hired_employee (
					id_employee SERIAL primary key,
					
					surname text NOT NULL,
					name text NOT NULL,
					middle_name text,
					birth_date date NOT NULL CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years'),
					sex boolean NOT NULL,
					
					passport_series text NOT NULL,
					passport_number text NOT NULL,
					passport_issued_whom text NOT NULL,
					passport_issued_when date NOT NULL,

					inn text NOT NULL UNIQUE,
					snils text NOT NULL UNIQUE,

					phone_number text NOT NULL,
					email text NOT NULL,

					post text NOT NULL,
					
					username text NOT NULL UNIQUE,
					password_hash text NOT NULL UNIQUE,
					
					
					created_at date DEFAULT CURRENT_DATE,
					is_working boolean DEFAULT TRUE	
					);
					''')
				conn.commit()

				# Таблица шаблонов рабочего расписания
				cur.execute('''
					CREATE TABLE IF NOT EXISTS work_shift(
					id_work SERIAL primary key,
					work_type text NOT NULL,
					start_time TIME(0) NOT NULL, 
					end_time TIME(0) NOT NULL CHECK (end_time >= start_time),
					break_duration TIME(0) NOT NULL
					);
					''')
				conn.commit()

				# Таблица расписания расписания работы сотрудников
				cur.execute('''
					CREATE TABLE IF NOT EXISTS employee_schedule(
					id_schedule SERIAL primary key,
					id_employee integer NOT NULL,
					id_work integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					FOREIGN KEY (id_work) REFERENCES work_shift (id_work),
					work_date date NOT NULL, 
					work_note text
					);
					''')

				conn.commit()
				# Таблица больниц. Лучше пока сделать так, чтобы она была одна
				cur.execute('''
					CREATE TABLE IF NOT EXISTS hospital(
						id_hospital SERIAL primary key,
						name text NOT NULL,
						date_foundation date NOT NULL
						);
					''')

				conn.commit()

				# Таблица строений
				cur.execute('''
					CREATE TABLE IF NOT EXISTS building(
						id_building SERIAL primary key,
						id_hospital integer NOT NULL,
						FOREIGN KEY (id_hospital) REFERENCES hospital (id_hospital),
						name text NOT NULL,
						date_foundation date NOT NULL
						);
					''')

				conn.commit()
				# Таблица отделений
				cur.execute('''
					CREATE TABLE IF NOT EXISTS department(
						id_department SERIAL primary key,
						id_building integer NOT NULL,
						FOREIGN KEY (id_building) REFERENCES building (id_building),
						name text NOT NULL,
						date_foundation date NOT NULL
						);
					''')
				conn.commit()

				cur.execute('''
					CREATE TABLE IF NOT EXISTS room(
						id_room SERIAL primary key,
						id_department integer NOT NULL,
						FOREIGN KEY (id_department) REFERENCES department (id_department),
						name text NOT NULL
						);
					''')
				conn.commit()


				# Таблица рабочего места сотрудников
				cur.execute('''
					CREATE TABLE IF NOT EXISTS employee_workplace(
					id_workplace SERIAL primary key,
					id_employee integer NOT NULL UNIQUE,
					id_department integer,
					id_room integer,
					FOREIGN KEY (id_employee) REFERENCES hired_employee(id_employee),
					FOREIGN KEY (id_department) REFERENCES department(id_department),
					FOREIGN KEY (id_room) REFERENCES room(id_room)
						);
					''')
				conn.commit()


				# Таблица пациентов
				cur.execute('''
					CREATE TABLE IF NOT EXISTS patient(
						id_patient SERIAL primary key,
						surname text NOT NULL,
						name text NOT NULL,
						middle_name text NOT NULL,
						date_of_birth date NOT NULL,
						sex boolean NOT NULL,
						
						passport_series text NOT NULL,
						passport_number text NOT NULL,
						passport_issued_whom text NOT NULL,
						passport_issued_when date NOT NULL,

						snils text UNIQUE,
						polis text UNIQUE,

						phone_number text NOT NULL,
						email text NOT NULL,
						
						
						username text NOT NULL UNIQUE,
						password_hash text NOT NULL UNIQUE,

						in_hospital boolean NOT NULL,
						id_room integer,
						FOREIGN KEY (id_room) REFERENCES room(id_room),
						id_hospital integer,
						FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
						);
					''')
				conn.commit()

				# Таблица приемов врача
				cur.execute('''
					CREATE TABLE IF NOT EXISTS reception_schedule(
					id_reception_schedule SERIAL primary key,
					id_employee integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					reception_type text NOT NULL,
					reception_date date NOT NULL, 
					start_time TIME(0) NOT NULL, 
					end_time TIME(0) NOT NULL,
					id_patient integer,
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					reception_note text,
					status text
					);
					''')
				conn.commit()


				conn.commit()
				# Таблица история болезней пациентов
				cur.execute('''
					CREATE TABLE IF NOT EXISTS medical(
					id_medical SERIAL primary key,
					id_patient integer NOT NULL,
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					id_employee integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					medical_date date NOT NULL DEFAULT CURRENT_DATE, 
					medical_time TIME(0) NOT NULL DEFAULT LOCALTIME,
					medical_text text NOT NULL
					)
				''')

				# Таблица историй анализов
				cur.execute('''
					CREATE TABLE IF NOT EXISTS analysis(
					id_analysis SERIAL primary key,
					id_patient integer NOT NULL,
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					id_employee integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					analysis_date date NOT NULL DEFAULT CURRENT_DATE, 
					analysis_time TIME(0) NOT NULL DEFAULT LOCALTIME,
					analysis_text text NOT NULL
					)
				''')

				# Таблица историй приёмов/посещений врачом
				cur.execute('''
					CREATE TABLE IF NOT EXISTS session(
					id_session SERIAL primary key,
					id_patient integer NOT NULL,
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					id_employee integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					session_date date NOT NULL DEFAULT CURRENT_DATE, 
					session_time TIME(0) NOT NULL DEFAULT LOCALTIME,
					session_text text NOT NULL
					)
				''')

				# Таблица историй назначений
				cur.execute('''
					CREATE TABLE IF NOT EXISTS appointment(
					id_appointment SERIAL primary key,
					id_patient integer NOT NULL,
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					id_employee integer NOT NULL,
					FOREIGN KEY (id_employee) REFERENCES hired_employee (id_employee),
					appointment_date date NOT NULL DEFAULT CURRENT_DATE, 
					appointment_time TIME(0) NOT NULL DEFAULT LOCALTIME,
					appointment_text text NOT NULL
					)
				''')

				cur.execute('''
					CREATE TABLE IF NOT EXISTS payment(
					id_payment SERIAL primary key,
					id_patient integer NOT NULL, 
					FOREIGN KEY (id_patient) REFERENCES patient (id_patient),
					id_session integer NOT NULL,
					FOREIGN KEY (id_session) REFERENCES session (id_session),
					payment_amount integer NOT NULL
					)
				
				''')

				cur.execute('''
					CREATE TABLE IF NOT EXISTS menu(
					id_menu SERIAL primary key,
					menu_text text NOT NULL					
					)
				''')

				print("все норм")
				return



def add_default_admin():
	with psycopg2.connect(
		dbname = DEFAULT_DATABASE_NAME,
			user = DB_USER,
			password = DB_PASSWORD,
			host = DB_HOST,
			port = DB_PORT
			) as conn:
			with conn.cursor() as cur:
				password_hash = pbkdf2_sha256.hash("admin")
				cur.execute('''
								INSERT INTO hired_employee(
								surname, name, middle_name, birth_date, sex, passport_series, passport_number,
								passport_issued_whom, passport_issued_when, inn, snils,phone_number, email, post, username, password_hash)
								VALUES
								(%s, %s, %s, %s, %s, %s, %s,
								%s, %s, %s, %s, %s, %s, %s, %s, %s)
							''', ("admin surname", "admin name", "admin middle_name", "2000-1-1", False, "admin passport_series",
								  "admin passport_number",
								  "admin passport_issued_whom", "2001-1-1", "admin inn", "admin snils",
								  "admin phone_number", "admin email", "admin", "admin", password_hash))
				conn.commit()


def add_default_work_shift():
	with psycopg2.connect(
		dbname = DEFAULT_DATABASE_NAME,
			user = DB_USER,
			password = DB_PASSWORD,
			host = DB_HOST,
			port = DB_PORT
			) as conn:
			with conn.cursor() as cur:
				cur.execute('''
					INSERT INTO work_shift(work_type, start_time, end_time, break_duration) VALUES
					(%s, %s, %s, %s)				
				''', ("Рабочий день", "09:00:00", "18:00:00", "1:30:00"))
			conn.commit()




def add_sm_patient():
	with psycopg2.connect(
		dbname = DEFAULT_DATABASE_NAME,
			user = DB_USER,
			password = DB_PASSWORD,
			host = DB_HOST,
			port = DB_PORT
			) as conn:
			with conn.cursor() as cur:
				username = "patient"
				password_hash = pbkdf2_sha256.hash("patient")

				cur.execute('''
					INSERT INTO patient(surname, name, middle_name, date_of_birth, sex, passport_series, passport_number, passport_issued_whom,
					passport_issued_when,  phone_number, email, username, password_hash, in_hospital) VALUES
					(%s, %s, %s, %s, %s, %s, %s, %s, 
					%s, %s, %s, %s, %s, %s)				
				''', ("Фамилия", "Имя", "Отчество", "1990-01-01", True, 123, 456, "FROM USA", "2000-01-01", "+7900000000", "aboba@mail.ru", username, password_hash, False))
			conn.commit()


def check_smth():
	with psycopg2.connect(
		dbname = DEFAULT_DATABASE_NAME,
			user = DB_USER,
			password = DB_PASSWORD,
			host = DB_HOST,
			port = DB_PORT
			) as conn:
			with conn.cursor() as cur:
				# cur.execute('''SELECT column_name, column_default, is_nullable
				# 	FROM information_schema.columns
				# 	WHERE table_name = 'medical';''')
				# rows = cur.fetchall()
				# print(rows)
				#
				# cur.execute('''SELECT tgname FROM pg_trigger WHERE tgrelid = 'medical'::regclass AND NOT tgisinternal;''')
				# rows = cur.fetchall()
				# print(rows)
				# cur.execute('''SELECT * FROM hired_employee''')
				# rows = cur.fetchall()
				# print(rows)
				# cur.execute('''SELECT * FROM employee_schedule''')
				# rows = cur.fetchall()
				# print(rows)
				# cur.execute('''SELECT * FROM work_shift''')
				# rows = cur.fetchall()
				# print(rows)
				# cur.execute('''SELECT * FROM patient''')
				# rows = cur.fetchall()
				# print(rows)
				cur.execute('''SELECT * FROM reception_schedule''')


				rows = cur.fetchall()
				print(rows)





if __name__ == "__main__":
	create_db()
	add_default_admin()
	add_default_work_shift()
	add_sm_patient()
	#check_smth()
	pass