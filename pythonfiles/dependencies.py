from fastapi import HTTPException
import pandas
import csv
import time
import jwt

DEFAULT_DATABASE_NAME = 'medical_institution_coursework_db'
DEFAULT_PATH_PERMISSION_FILE = "description of permissions.csv"
DEFAULT_TOKEN_LIFE_TIME = 1000000
SECRET_KEY = ""
ALGORITHM = "HS256"
DB_USER = "postgres"
DB_PASSWORD = "password"
DB_HOST = "localhost"
DB_PORT = "5433"




def decode_jwt(token:str):
	try:
		payload = jwt.decode(token, SECRET_KEY, algorithms = [ALGORITHM])
		if payload.get("exp") and payload["exp"] < time.time():
			raise jwt.ExpiredSignatureError()
		return payload
	except jwt.ExpiredSignatureError:
		raise HTTPException(status_code=401, detail="Token expired")
	except jwt.PyJWTError:
		raise HTTPException(status_code=401, detail="Invalid token")

def create_access_token(data: dict):
	to_encode = data.copy()
	to_encode["exp"] = time.time() + DEFAULT_TOKEN_LIFE_TIME
	return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

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

def get_df_roles_and_functions():
	with open(DEFAULT_PATH_PERMISSION_FILE, newline="",  encoding='utf-8') as csvf:
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


		df_roles = pandas.DataFrame(data_roles, columns=roles, index=lines)
		df_functions = pandas.DataFrame(data_functions, columns=functions, index=lines)
		return df_roles, df_functions

# Комбинация define_permission и get_df_roles_and_functions для удобства
def open_csv_and_define_permission(current_role:str, current_function:str):
	df_roles, df_functions = get_df_roles_and_functions()
	return define_permission(current_role, current_function, df_roles, df_functions)
