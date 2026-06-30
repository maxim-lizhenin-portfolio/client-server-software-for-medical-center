import psycopg2
DEFAULT_DATABASE_NAME = 'proba_course'
import json
import time
import random
def create_data_base():
	conn = psycopg2.connect(
			dbname="postgres",
		user="postgres",
		password="password",
		host="localhost",
		port="5432"
		)
	conn.autocommit = True
	with conn.cursor() as cur:
		cur.execute(f'CREATE DATABASE {DEFAULT_DATABASE_NAME};')
		conn.commit()
	return


def create_and_fill_table():
	with psycopg2.connect(
			dbname = DEFAULT_DATABASE_NAME,
		user = "postgres",
		password = "password",
		host = "localhost",
		port = "5432"
		) as conn:
		with conn.cursor() as cur:
			cur.execute('DROP TABLE IF EXISTS proba_table;')
			conn.commit()
			cur.execute('''
				CREATE TABLE IF NOT EXISTS proba_table (
					id SERIAL PRIMARY KEY,
					random_num INTEGER
				);
			''')
			conn.commit()
			for i in range(10):
				num = int(random.randint(0, 1000))
				cur.execute('INSERT INTO proba_table (random_num) VALUES (%s)', (num, ))
			conn.commit()

import pandas
tables = ["hired_employee", "work_shift", "employee_schedule", "hospital", "building", "department",
		  "room", "employee_workplace", "medical_card", "patient", "reception_schedule"]

roles	 = ["специалист по приему сотрудников", "составитель штатного расписания и структуры лечебного заведения",
		 "специалист по работе с клиентами", "врач", "медицинская сестра", "лаборант", "регистратор", "пациент", "admin"]

dt = {"hired_employee": 		["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"work_shift": 			["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"employee_schedule":	["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"hospital": 			["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"building": 			["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"department": 			["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"room": 				["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"employee_workplace":	["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"medical_card": 		["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"patient": 				["n", "n", "n", "n", "n", "n", "n", "n", "n"],
		"reception_schedule": 	["n", "n", "n", "n", "n", "n", "n", "n", "n"]
	  }
import csv

def define_permission(current_role:str, current_function:str, df_r:pandas.DataFrame, df_f:pandas.DataFrame):
	table_role_perm = df_r[current_role]
	table_fun_perm = df_f[current_function]

	for i in range(len(table_role_perm)):
		if table_fun_perm.iloc[i] == "nr":
			continue
		if table_fun_perm.iloc[i] == "r":
			if table_role_perm.iloc[i] == "s":
				return False
			if table_role_perm.iloc[i] == "r" or table_role_perm.iloc[i] == "w":
				continue
			else: # на всякий
				return False
		if table_fun_perm.iloc[i] == "w":
			if table_role_perm.iloc[i] == "s":
				return False
			if table_role_perm.iloc[i] == "w":
				continue
			else:
				return False
	return True


if __name__ == "__main__":
	#create_data_base()
	#create_and_fill_table()
	# df = pandas.DataFrame(dt, columns=tables, index=roles)
	# print(df)
	# print(df["hired_employee"]["врач"])
	# print(df.loc["врач"]["hired_employee"])
	with open("description of permissions.csv", newline="",  encoding='utf-8') as csvf:
		read_csv = list(csv.reader(csvf, delimiter=";"))
		dl = read_csv[0].index("_functions_")
		lines = [read_csv[i][0] for i in range(1, len(read_csv))]

		roles = [read_csv[0][i] for i in range(1, dl)]
		functions = [read_csv[0][i] for i in range(dl+1, len(read_csv[0]))]

		data_roles = []
		for i in range(1, len(lines)+1):
			data_roles.append([])
			for j in range(1, dl):
				data_roles[i-1].append(read_csv[i][j])

		data_functions = []
		for i in range(1, len(lines)+1):
			data_functions.append([])
			for j in range(dl+1, len(read_csv[i])):
				data_functions[i-1].append(read_csv[i][j])

		print(lines)
		print(roles)
		for i in range(len(data_roles)):
			print(data_roles[i])

		print()
		for i in range(len(data_functions)):
			print(data_functions[i])
		print()

		df_roles = pandas.DataFrame(data_roles, columns=roles, index=lines)
		df_functions = pandas.DataFrame(data_functions, columns=functions, index=lines)
		print(df_roles)
		print(df_functions)

		print()
		if define_permission("admin", "get_data", df_roles, df_functions):
			print("Админу можно получить дату")
		else:
			print("Админу нельзя получить дату")
		if define_permission("admin", "add_employee", df_roles, df_functions):
			print("Админу можно добавить чела")
		else:
			print("Админу нельзя добавить чела")

	print("успешно")
