extends Control
const DEFAULT_LIMIT = 10
const FONT_PATH = "res://font/Inter-VariableFont_opsz,wght.ttf"

# ПУТИ

#Таблицы
@onready var patient_table = $VBoxContainer/MarCon_Tables_Patient
@onready var medical_table = $VBoxContainer/MarCon_Tables_Medical
@onready var analysis_table = $VBoxContainer/MarCon_Tables_Analysis
@onready var session_table = $VBoxContainer/MarCon_Tables_Session
@onready var appointment_table = $VBoxContainer/MarCon_Tables_Appointment
@onready var schedule_table = $VBoxContainer/MarCon_Tables_EmployeeSchedule
@onready var reception_table = $VBoxContainer/MarCon_Tables_ReceiptionSchedule


#STATE2
#Главное окно
@onready var marcon_addpatient = $VBoxContainer/MarCon_AddEmployee
#проверка полиса
@onready var marcon_checkvalidpolis = $VBoxContainer/MarCon_CheckValidPolis
# Выдача документов
@onready var marcon_getsnilspolis = $VBoxContainer/MarCon_GetSnilsPolis
# Таблица больниц
@onready var marcon_hospital = $VBoxContainer/MarCon_Tables_Hospital

# ДОПОЛНИТЕЛЬНОЕ МЕНЮ
@onready var additmenu_openhistoryof = $MarCon_AdditMenuOpenHistoryOf
@onready var additmenu_medicaladd = $MarCon_AdditMenu_MedicalAdd
@onready var additmenu_analysisadd = $MarCon_AdditMenu_AnalysisAdd
@onready var additmenu_sessionadd = $MarCon_AdditMenu_SessionAdd
@onready var additmenu_appointmentadd = $MarCon_AdditMenu_AppointmentAdd
@onready var additmenu_moreinfo = $MarCon_AdditMenu_MoreInfo
@onready var additmenu_changereceptionstatus = $MarCon_AdditMenu_ChangeReceptionStatus


#ЧТО ДОЛЖНО ЗАКРЫТЬСЯ ПРИ ВЫЗОВЕ СОСТОЯНИЯ
#STATE0
@onready var state0_list_for_close = [schedule_table, reception_table, additmenu_changereceptionstatus, marcon_hospital, additmenu_openhistoryof, marcon_addpatient, marcon_checkvalidpolis, marcon_getsnilspolis]
#STATE1
@onready var state1_list_for_close = [patient_table, medical_table, analysis_table, session_table, appointment_table, reception_table,
additmenu_openhistoryof, additmenu_medicaladd, additmenu_analysisadd, additmenu_sessionadd, additmenu_appointmentadd, additmenu_moreinfo]
@onready var state2_list_for_close = [marcon_addpatient, marcon_checkvalidpolis, marcon_getsnilspolis, additmenu_openhistoryof]



@onready var lbl_doctor_surname = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/HBoxContainer/surname
@onready var lbl_doctor_name = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/HBoxContainer/name
@onready var lbl_doctor_middlename = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/HBoxContainer/middle_name
@onready var lbl_data = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer5/HBoxContainer2/HBoxContainer/data
@onready var lbl_time = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer5/HBoxContainer2/HBoxContainer/time
@onready var textedit_text = $MarCon_AdditMenu_MoreInfo/VBoxContainer/VBoxContainer/MarginContainer6/HBoxContainer2/text
#TEXTEDITS
@onready var textedit_medical = $MarCon_AdditMenu_MedicalAdd/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/TextEdit
@onready var textedit_analysis = $MarCon_AdditMenu_AnalysisAdd/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/TextEdit
@onready var textedit_session = $MarCon_AdditMenu_SessionAdd/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/TextEdit
@onready var textedit_appointment = $MarCon_AdditMenu_AppointmentAdd/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/TextEdit

#OPTION BUTTONS
@onready var ob_receptionstatus = $MarCon_AdditMenu_ChangeReceptionStatus/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/OB_ReceptionStatus

#BUTTONS
@onready var but_openschedule = $VBoxContainer/MarCon_Tables_EmployeeSchedule/VBoxContainer/But_OpenReception



var request_types = {}
var current_script_state = 0

@onready var current_rect:int = -1
@onready var current_state:String =""
@onready var current_type:String = ""

@onready var tmr = $Timer
var tmr_type = ""

var current_selected_id_patient = -2

var state1_current_reception_date = -2
var state1_current_id_reception_schedule = -2

# СПИСКИ ПОЛУЧЕННЫХ ДАННЫ
var dicts = {
	"state0":{
		"patient": [],
		"medical": [],
		"analysis": [],
		"session": [],
		"appointment": [],
		"hospital": []
	},
	"state1":{
		"schedule": [],
		"reception": [],
		
	}
}

# СПИСКИ ЭЛЕМЕНТОВ
var lbls = {
	"state0":{
		"patient": [],
		"medical": [],
		"analysis": [],
		"session": [],
		"appointment": [],
		"hospital": []
	},
	"state1":{
		"schedule": [],
		"reception": [],
		
	}
}

var rects = {
	"state0":{
		"patient": [],
		"medical": [],
		"analysis": [],
		"session": [],
		"appointment": [],
		"hospital": []
	},
	"state1":{
		"schedule": [],
		"reception": []
		
	}
}


@onready var patient_gridrects = $VBoxContainer/MarCon_Tables_Patient/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var patient_gridlabels = $VBoxContainer/MarCon_Tables_Patient/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var medical_gridrects = $VBoxContainer/MarCon_Tables_Medical/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var medical_gridlabels = $VBoxContainer/MarCon_Tables_Medical/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var analysis_gridrects = $VBoxContainer/MarCon_Tables_Analysis/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var analysis_gridlabels = $VBoxContainer/MarCon_Tables_Analysis/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var session_gridrects = $VBoxContainer/MarCon_Tables_Session/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var session_gridlabels = $VBoxContainer/MarCon_Tables_Session/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var appointment_gridrects = $VBoxContainer/MarCon_Tables_Appointment/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var appointment_gridlabels = $VBoxContainer/MarCon_Tables_Appointment/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var schedule_gridrects = $VBoxContainer/MarCon_Tables_EmployeeSchedule/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/MarCon/GridCon_ForColorRects
@onready var schedule_gridlabels = $VBoxContainer/MarCon_Tables_EmployeeSchedule/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/GridCon_ForLabels

@onready var reception_gridrects = $VBoxContainer/MarCon_Tables_ReceiptionSchedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var reception_gridlabels = $VBoxContainer/MarCon_Tables_ReceiptionSchedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var hospital_gridrects = $VBoxContainer/MarCon_Tables_Hospital/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var hospital_gridlabels = $VBoxContainer/MarCon_Tables_Hospital/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels


# ПУТЬ К ТАБЛИЦАМ
@onready var path_to_grid_lbls = {
	"state0":{
		"patient": patient_gridlabels,
		"medical": medical_gridlabels,
		"analysis": analysis_gridlabels,
		"session": session_gridlabels,
		"appointment": appointment_gridlabels,
		"hospital": hospital_gridlabels
	},
	"state1":{
		"schedule": schedule_gridlabels,
		"reception": reception_gridlabels,
	
	}
}

@onready var path_to_grid_rects = {
	"state0":{
		"patient": patient_gridrects,
		"medical": medical_gridrects,
		"analysis": analysis_gridrects,
		"session": session_gridrects,
		"appointment": appointment_gridrects,
		"hospital": hospital_gridrects
	},
	"state1":{
		"schedule": schedule_gridrects,
		"reception": reception_gridrects,
		
	}
}



# Функции отправки запроса
func send_request_PATIENT_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "patient/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

#MEDICAL
func send_request_MEDICAL_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/medical/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "medical/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_MEDICAL_ADD():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/medical/add"
	var data = {
		"token": gs.tkn, 
		"id_patient": current_selected_id_patient, 
		"medical_text": textedit_medical.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "medical/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


#ANALYSIS
func send_request_ANALYSIS_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/analysis/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "analysis/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
func send_request_ANALYSIS_ADD():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/analysis/add"
	var data = {
		"token": gs.tkn, 
		"id_patient": current_selected_id_patient, 
		"analysis_text": textedit_analysis.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "analysis/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

#SESSION
func send_request_SESSION_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/session/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "session/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
func send_request_SESSION_ADD():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/session/add"
	var data = {
		"token": gs.tkn, 
		"id_patient": current_selected_id_patient, 
		"session_text": textedit_session.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "session/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


#APPOINTMENT
func send_request_APPOINTMENT_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/appointment/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "appointment/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
func send_request_APPOINTMENT_ADD():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/appointment/add"
	var data = {
		"token": gs.tkn, 
		"id_patient": current_selected_id_patient, 
		"appointment_text": textedit_appointment.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "appointment/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

#STATE1
#schedule
func send_request_EMPLOYEE_SCHEDULE_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee_schedule/get_info_by_current_username?token={tkn}&id_employee={id_employee}".format({
		"tkn": gs.tkn})
		
	print("url get_info_by_current_username employee_schedule:", url)
	req.request(url)
	request_types[req] = "employee_schedule/get_info_by_current_username"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_RECEPTION_SCHEDULE_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/reception_schedule/get_by_current_username?token={tkn}&id_employee={id_employee}&reception_date={reception_date}".format({
		"tkn": gs.tkn,
		"reception_date": state1_current_reception_date})
	print("url get_by_current_username reception_schedule:", url)
	req.request(url)
	request_types[req] = "reception_schedule/get_by_current_username"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
func send_request_RECEPTION_SCHEDULE_UPDATE_STATUS():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/reception_schedule/update_status"
	var current_status = ob_receptionstatus.get_item_text(ob_receptionstatus.selected)
	print(current_status)
	if current_status == "Незавершен":
		current_status = "Not completed"
	elif current_status == "Завершен":
		current_status = "Completed"
	
	var data = {
		"token": gs.tkn,
		"id_reception_schedule": state1_current_id_reception_schedule,
		"status": current_status
	}
	print(url)
	print("ТЕКУЩИЙ id_reception_schedule = ", state1_current_id_reception_schedule)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "reception_schedule/update_status"
	req.request_completed.connect(_on_http_request_request_completed.bind(req)) 


# STATE2
# ADD PATIENT
func send_request_ADD_PATIENT():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/add"
	var data = ({
		"token": gs.tkn,
		"surname":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer/surname.text,
		"name":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer2/name.text,
		"middle_name":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer3/middle_name.text,
		"date_of_birth":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer4/HBoxContainer/date_of_birth_year.text + "-" + $VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer4/HBoxContainer/date_of_birth2_month.text + "-" + $VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer4/HBoxContainer/date_of_birth3_day.text,
		"sex":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer5/sex_button.button_pressed,
		"passport_series":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer6/passport_series.text,
		"passport_number":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer7/passport_number.text,
		"passport_issued_whom":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer8/passport_issued_whom.text,
		"passport_issued_when":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer9/HBoxContainer/issued_when_year.text + "-" + $VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer9/HBoxContainer/issued_when_month.text + "-" + $VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer9/HBoxContainer/issued_when_day.text,
		"snils":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer10/inn.text,
		"polis":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer11/snils.text,
		"phone_number":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer12/phone_number.text,
		"email":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer13/email.text,
		"in_hospital":$VBoxContainer/MarCon_AddEmployee/VBoxContainer/HBoxContainer14/OptionButton.text.to_lower()
		})
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "patient/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_PATIENT_CHECK_STATUS():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/check_polis"
	
	var data = {
		"token": gs.tkn,
		"id_patient": current_selected_id_patient,
		"polis": $VBoxContainer/MarCon_CheckValidPolis/VBoxContainer/HBoxContainer/surname.text
	}
	print(url)
	print("ТЕКУЩИЙ id_reception_schedule = ", current_selected_id_patient)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "patient/check_polis"
	req.request_completed.connect(_on_http_request_request_completed.bind(req)) 

func send_request_PATIENT_GET_SNILS_POLIS():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/get_snils_polis?token={tkn}&id_patient={id_patient}".format({
		"tkn": gs.tkn, "id_patient": current_selected_id_patient})
		
	print("url get_snils_polis patient:", url)
	req.request(url)
	request_types[req] = "patient/get_snils_polis"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_HOSPITAL_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/hospital/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "hospital/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
var current_selected_id_hospital = -2
func send_request_PATIENT_SET_HOSPITAL(type: String):
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/set_hospital"
	var csih
	if type == "hospital":
		csih = str(current_selected_id_hospital)
	else:
		csih = "None"
	
	var data = {
		"token": gs.tkn,
		"id_patient": current_selected_id_patient,
		"id_hospital": csih
	}
	print(url)
	print("ТЕКУЩИЙ id_hospital = ", current_selected_id_hospital)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "patient/set_hospital"
	req.request_completed.connect(_on_http_request_request_completed.bind(req)) 


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, req):
	if result != OK:
		print("Ошибка запроса:", result)
		request_types.erase(req)
		req.queue_free()
		return
		
	var data = JSON.parse_string(body.get_string_from_utf8())
	var type = request_types[req]
	print(data)
	if current_script_state == 0:
		match type:
			"patient/get":
				print(type, data)
				dicts["state0"]["patient"] = data
				create_table("state0", "patient")
			"medical/get":
				print(type, data)
				dicts["state0"]["medical"] = data
				create_table("state0", "medical")
			"medical/add":
				print("medical/add ", data["medical/add"])
				tmr_type = "medical"
				tmr.start(0.5)
			"analysis/get":
				print(type, data)
				dicts["state0"]["analysis"] = data
				create_table("state0", "analysis")
			"analysis/add":
				print("analysis/add ", data["analysis/add"])
				tmr_type = "analysis"
				tmr.start(0.5)
			"session/get":
				print(type, data)
				dicts["state0"]["session"] = data
				create_table("state0", "session")
			"session/add":
				print("session/add ", data["session/add"])
				tmr_type = "session"
				tmr.start(0.5)
			"appointment/get":
				print(type, data)
				dicts["state0"]["appointment"] = data
				create_table("state0", "appointment")
			"appointment/add":
				print("appointment/add ", data["appointment/add"])
				tmr_type = "appointment"
				tmr.start(0.5)
			"patient/check_polis":
				print(type, data)
				$VBoxContainer/MarCon_CheckValidPolis/VBoxContainer/MarginContainer2/ValidPolisResult.text = data["result"]
			"patient/get_snils_polis":
				print(type, " ", data)
				lbl_snils.text = data[0]["snils"]
				lbl_polis.text = data[0]["polis"]
			"hospital/get":
				print(type, data)
				dicts["state0"]["hospital"] = data
				create_table("state0", "hospital")
			"patient/set_hospital":
				print(type, " ", data)
	elif current_script_state == 1:
		match type:
			"employee_schedule/get_info_by_current_username":
				print(type, data)
				dicts["state1"]["schedule"] = data
				create_table("state1", "schedule")
				pass
			"reception_schedule/get_by_current_username":
				print(type, data)
				dicts["state1"]["reception"] = data
				create_table("state1", "reception")
			"reception_schedule/update_status":
				print("reception_schedule/update_status ", data)
				tmr_type = "reception"
				tmr.start(0.5)
	elif current_script_state == 2:
		match type:
			"patient/add":
				print(type, " ", data)
			
				
	else:
		# НЕ ТРОГАТЬ
		pass
				
	request_types.erase(req)
	req.queue_free()
@onready var lbl_snils = $VBoxContainer/MarCon_GetSnilsPolis/VBoxContainer/MarginContainer2/HBoxContainer/Label2
@onready var lbl_polis = $VBoxContainer/MarCon_GetSnilsPolis/VBoxContainer/MarginContainer3/HBoxContainer2/Label2

var patient_surname = ""
var patient_name = ""
var patient_middlename = ""
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if current_rect == -1:
			return
		
		# НАЖАТИЕ НА ТАБЛИЦЫ ПРИ STATE == 0
		if current_script_state == 0:
			if current_type == "patient":
				var columns_count = 6
				var current_patient = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				current_selected_id_patient = dicts["state0"][current_type][current_patient]["id_patient"]
				patient_surname = dicts["state0"][current_type][current_patient]["surname"]
				patient_name = dicts["state0"][current_type][current_patient]["name"]
				patient_middlename = dicts["state0"][current_type][current_patient]["middle_name"]
				print(current_selected_id_patient)
				additmenu_openhistoryof.visible = true
			elif current_type == "medical":
				var columns_count = 6
				var current_medical = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				lbl_doctor_surname.text = dicts["state0"][current_type][current_medical]["surname"]
				lbl_doctor_name.text = dicts["state0"][current_type][current_medical]["name"]
				lbl_doctor_middlename.text = dicts["state0"][current_type][current_medical]["middle_name"]
				lbl_data.text = dicts["state0"][current_type][current_medical]["medical_date"]
				lbl_time.text = dicts["state0"][current_type][current_medical]["medical_time"]
				textedit_text.text = dicts["state0"][current_type][current_medical]["medical_text"] 
				additmenu_moreinfo.visible = true
			elif current_type == "analysis":
				var columns_count = 6
				var current_analysis = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				lbl_doctor_surname.text = dicts["state0"][current_type][current_analysis]["surname"]
				lbl_doctor_name.text = dicts["state0"][current_type][current_analysis]["name"]
				lbl_doctor_middlename.text = dicts["state0"][current_type][current_analysis]["middle_name"]
				lbl_data.text = dicts["state0"][current_type][current_analysis]["analysis_date"]
				lbl_time.text = dicts["state0"][current_type][current_analysis]["analysis_time"]
				textedit_text.text = dicts["state0"][current_type][current_analysis]["analysis_text"] 
				additmenu_moreinfo.visible = true
			elif current_type == "session":
				var columns_count = 6
				var current_session = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				lbl_doctor_surname.text = dicts["state0"][current_type][current_session]["surname"]
				lbl_doctor_name.text = dicts["state0"][current_type][current_session]["name"]
				lbl_doctor_middlename.text = dicts["state0"][current_type][current_session]["middle_name"]
				lbl_data.text = dicts["state0"][current_type][current_session]["session_date"]
				lbl_time.text = dicts["state0"][current_type][current_session]["session_time"]
				textedit_text.text = dicts["state0"][current_type][current_session]["session_text"] 
				additmenu_moreinfo.visible = true
			elif current_type == "appointment":
				var columns_count = 6
				var current_appointment = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				lbl_doctor_surname.text = dicts["state0"][current_type][current_appointment]["surname"]
				lbl_doctor_name.text = dicts["state0"][current_type][current_appointment]["name"]
				lbl_doctor_middlename.text = dicts["state0"][current_type][current_appointment]["middle_name"]
				lbl_data.text = dicts["state0"][current_type][current_appointment]["appointment_date"]
				lbl_time.text = dicts["state0"][current_type][current_appointment]["appointment_time"]
				textedit_text.text = dicts["state0"][current_type][current_appointment]["appointment_text"] 
				additmenu_moreinfo.visible = true
			elif current_type == "hospital":
				var columns_count = 2
				var current_hospital = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				current_selected_id_hospital = dicts["state0"][current_type][current_hospital]["id_hospital"]
				additmenu_sethspital.visible = true
		elif current_script_state == 1:
			if current_type == "schedule":
				var columns_count = 5
				var current_schedule = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state1")
				state1_current_reception_date = dicts["state1"][current_type][current_schedule]["work_date"]
				print(state1_current_reception_date)
				but_openschedule.disabled = false
			elif current_type == "reception":
				var columns_count = 8
				var current_reception = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state1")
				state1_current_id_reception_schedule = dicts["state1"][current_type][current_reception]["id_reception_schedule"]
				print(state1_current_id_reception_schedule)
				additmenu_sethspital.visible = true
			
				
				

func _on_timer_timeout() -> void:
	match tmr_type:
		"medical":
			send_request_MEDICAL_GET()
		"analysis":
			send_request_ANALYSIS_GET()
		"session":
			send_request_SESSION_GET()
		"appointment":
			send_request_APPOINTMENT_GET()
		"reception":
			send_request_RECEPTION_SCHEDULE_GET()
		
	tmr.stop()
	pass # Replace with function body.


func _ready() -> void:
	pass
	
# ЗАПОЛНЕНИЕ ТАБЛИЦ
func make_label(text:String) -> Label:
	var lbl = Label.new()
	
	lbl.text = text.replace("\n", " ")
	lbl.clip_text = true
	lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.size_flags_vertical = Control.SIZE_FILL
	lbl.add_theme_color_override("font_color", Color.html("#333333"))
	lbl.add_theme_font_override("font", load(FONT_PATH))
	lbl.add_theme_font_size_override("font_size", 16)
	return lbl

func make_colrect(clr:bool, pos:int, state:String, type:String, columns_count:int) -> ColorRect:
	var rect = ColorRect.new()
	if clr:
		rect.color = Color.html("#ffced2")
	else:
		rect.color = Color.html("#aee6e7")
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rect.mouse_entered.connect(rect_highlighting.bind(rect, columns_count))
	rect.mouse_exited.connect(rect_unhighlighting.bind(rect, columns_count))
	rect.set_meta("pos", pos)
	rect.set_meta("state", state)
	rect.set_meta("type", type)
	rect.set_meta("selected", false)
	return rect


# ФУНКЦИИ ПОДВЯЗЫВАЮЩИЕСЯ К ОБЪЕКТАМ С ПОМОЩЬЮ СИГНАЛОВ
# Функция для включения подсветки линии таблицы
func rect_highlighting(rect, columns_count):
	current_rect = rect.get_meta("pos")
	current_state = rect.get_meta("state")
	current_type = rect.get_meta("type")
	

	var cur_color:Color
	if rect.color == Color.html("#ffced2"):
		cur_color = Color.html("#f89b99")
	elif rect.color == Color.html("#aee6e7"):
		cur_color = Color.html("#73d7d8")
	else:
		cur_color = rect.color
		
	var start_pos = rect.get_meta("pos") - (rect.get_meta("pos") % columns_count)
	for i in range(start_pos, start_pos+columns_count):
		rects[current_state][current_type][i].color = cur_color
	
# Функция для выключения подсветки линии таблицы	
func rect_unhighlighting(rect, columns_count):
	current_rect = -1
	if rect.get_meta("selected") == true:
		return

	var cur_color:Color
	
	if rect.color == Color.html("#f89b99"):
		cur_color = Color.html("#ffced2")
	elif rect.color == Color.html("#73d7d8"):
		cur_color = Color.html("#aee6e7")
	else:
		cur_color = rect.color
		
	var start_pos = rect.get_meta("pos") - (rect.get_meta("pos") % columns_count)

	for i in range(start_pos, start_pos+columns_count):
		rects[current_state][current_type][i].color = cur_color
	current_type = ""
	current_state = ""


func keep_rect_highlighting(columns_count:int, state: String):
	var start_pos = current_rect - (current_rect % columns_count)
	for i in range(len(rects[state][current_type])):
		if (i >= start_pos) and (i < start_pos+columns_count):
			continue
		rects[state][current_type][i].set_meta("selected", false)
		if rects[state][current_type][i].color == Color.html("#f89b99"):
			rects[state][current_type][i].color = Color.html("#ffced2")
		elif rects[state][current_type][i].color == Color.html("#73d7d8"):
			rects[state][current_type][i].color = Color.html("#aee6e7")
		else:
			print("остальное сбросится")
	for i in range(start_pos, start_pos+columns_count):
		rects[state][current_type][i].set_meta("selected", true)			


func create_table(state:String, type:String)->void:
	#Очистка текста и заливки таблицы
	for lbl in lbls[state][type]:
		lbl.queue_free()
	for rect in rects[state][type]:
		rect.queue_free()
	#Определение списков как пустых
	lbls[state][type].clear()
	rects[state][type].clear()
	
	var flag = true
	var pos = 0
	
	var fields = {
		"state0":{
			"patient": ["surname", "name", "middle_name", "date_of_birth", "sex", "in_hospital"],
			"medical": ["surname", "name", "middle_name", "medical_date", "medical_time", "medical_text"],
			"analysis": ["surname", "name", "middle_name", "analysis_date", "analysis_time", "analysis_text"],
			"session": ["surname", "name", "middle_name", "session_date", "session_time", "session_text"],
			"appointment": ["surname", "name", "middle_name", "appointment_date", "appointment_time", "appointment_text"]	,
			"hospital": ["name", "date_foundation"]		
			},
		"state1":{
			"schedule": ["work_date", "start_time", "end_time", "break_duration", "reception_count"],
			"reception": ["reception_type", "start_time", "end_time", "surname", "name", "middle_name", "reception_note", "status"]
			
			}	
	}
	
	for i in range(len(dicts[state][type])):
		for field in fields[state][type]:
			var lbl = make_label(dicts[state][type][i][field])
			var rect = make_colrect(flag, pos, state, type, len(fields[state][type]))
			
			path_to_grid_lbls[state][type].add_child(lbl)
			path_to_grid_rects[state][type].add_child(rect)

			lbls[state][type].append(lbl)
			rects[state][type].append(rect)
			pos += 1
		flag = !flag


func _on_but_activate_check_patient_button_down() -> void:
	for element in state0_list_for_close:
		element.visible = false
	for element in state1_list_for_close:
		element.visible = false
	current_script_state = 0
	patient_table.visible = true
	send_request_PATIENT_GET()
	pass # Replace with function body.

#ФУНКЦИИ ОТКРЫТИЯ ТАБЛИЦ medical, analysis, session, appointments
func _on_but_open_medical_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	medical_table.visible = true
	$VBoxContainer/MarCon_Tables_Medical/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "История болезней пациента   <{surname} {name} {middle_name}>".format({
	"surname": patient_surname,
	"name": patient_name,
	"middle_name": patient_middlename}) 
	send_request_MEDICAL_GET()
	pass
func _on_but_open_analysis_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	analysis_table.visible = true
	$VBoxContainer/MarCon_Tables_Analysis/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "История анализов пациента   <{surname} {name} {middle_name}>".format({
	"surname": patient_surname,
	"name": patient_name,
	"middle_name": patient_middlename})
	send_request_ANALYSIS_GET()
	pass
func _on_but_open_session_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	session_table.visible = true
	$VBoxContainer/MarCon_Tables_Session/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "История посещений пациента   <{surname} {name} {middle_name}>".format({
	"surname": patient_surname,
	"name": patient_name,
	"middle_name": patient_middlename})
	send_request_SESSION_GET()
	pass
func _on_but_open_appointment_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	appointment_table.visible = true
	$VBoxContainer/MarCon_Tables_Appointment/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "История назначений пациенту   <{surname} {name} {middle_name}>".format({
	"surname": patient_surname,
	"name": patient_name,
	"middle_name": patient_middlename})
	send_request_APPOINTMENT_GET()
	pass
	
	
	
#ФУНКЦИИ ПО СИГНАЛАМ ОТКРЫТИЯ ДОП МЕНЮ
func _on_but_medical_add_button_down() -> void:
	additmenu_medicaladd.visible = true
	pass
func _on_but_analysis_add_button_down() -> void:
	additmenu_analysisadd.visible = true
	pass
func _on_but_session_add_button_down() -> void:
	additmenu_sessionadd.visible = true
	pass
func _on_but_appointment_add_button_down() -> void:
	additmenu_appointmentadd.visible = true
	pass
	
		
#ФУНКЦИИ ПО СИГНАЛАМ ДЛЯ ЗАКРЫТИЯ ДОП МЕНЮ
func _on_but_close_addit_menu_open_history_of_button_down() -> void:
	additmenu_openhistoryof.visible = false
	pass
func _on_but_close_addit_menu_medical_add_button_down() -> void:
	additmenu_medicaladd.visible = false
	pass
func _on_but_close_addit_menu_analysis_add_button_down() -> void:
	additmenu_analysisadd.visible = false
	pass
func _on_but_close_addit_menu_session_add_button_down() -> void:
	additmenu_sessionadd.visible = false
	pass
func _on_but_close_addit_menu_appointment_add_button_down() -> void:
	additmenu_appointmentadd.visible = false
	pass
func _on_but_close_addit_menu_more_info_button_down() -> void:
	additmenu_moreinfo.visible = false
	pass


# ФУНКЦИИ ПО СИГНАЛАМ ДЛЯ ЗАПРОСА НА ВСТАВКУ
func _on_but_make_request_medical_add_button_down() -> void:
	additmenu_medicaladd.visible = false
	send_request_MEDICAL_ADD()
	pass
func _on_but_make_request_analysis_add_button_down() -> void:
	additmenu_analysisadd.visible = false
	send_request_ANALYSIS_ADD()
	pass
func _on_but_make_request_session_add_button_down() -> void:
	additmenu_sessionadd.visible = false
	send_request_SESSION_ADD()
	pass
func _on_but_make_request_appointment_add_button_down() -> void:
	additmenu_appointmentadd.visible = false
	send_request_APPOINTMENT_ADD()
	pass


# ФУНКЦИИ ВОЗВРАТА НАЗАД ПРИ НАЖАТИИ НА КНОПКИ
func _on_but_medical_back_to_patient_button_down() -> void:
	medical_table.visible = false
	additmenu_medicaladd.visible = false
	additmenu_moreinfo.visible = false
	patient_table.visible = true
	pass
func _on_but_analysis_back_to_patient_button_down() -> void:
	analysis_table.visible = false
	additmenu_analysisadd.visible = false
	additmenu_moreinfo.visible = false
	patient_table.visible = true
	pass
func _on_but_session_back_to_patient_button_down() -> void:
	session_table.visible = false
	additmenu_sessionadd.visible = false
	additmenu_moreinfo.visible = false
	patient_table.visible = true
	pass
func _on_but_appointment_back_to_patient_button_down() -> void:
	appointment_table.visible = false
	additmenu_appointmentadd.visible = false
	additmenu_moreinfo.visible = false
	patient_table.visible = true
	pass



#STATE1
func _on_but_activate_check_employee_schedule_button_down() -> void:
	current_script_state = 1
	for element in state1_list_for_close:
		element.visible = false
	for element in state2_list_for_close:
		element.visible = false
	schedule_table.visible = true
	send_request_EMPLOYEE_SCHEDULE_GET()
	pass # Replace with function body.



func _on_but_open_schedule_button_down() -> void:
	schedule_table.visible = false
	reception_table.visible = true
	$VBoxContainer/MarCon_Tables_ReceiptionSchedule/VBoxContainer/HBoxContainer/VBoxContainer2/Label.text = "Приёмы на " + state1_current_reception_date
	
	send_request_RECEPTION_SCHEDULE_GET()
	pass


func _on_but_update_reception_status_button_down() -> void:
	additmenu_changereceptionstatus.visible = false
	send_request_RECEPTION_SCHEDULE_UPDATE_STATUS()
	pass


func _on_but_close_addit_menu_change_reception_status_button_down() -> void:
	additmenu_changereceptionstatus.visible = false
	pass


func _on_but_go_back_to_schedule_button_down() -> void:
	additmenu_changereceptionstatus.visible = false
	reception_table.visible = false
	schedule_table.visible = true
	pass # Replace with function body.


func _on_button_button_down() -> void:
	send_request_ADD_PATIENT()
	pass # Replace with function body.


func _on_but_activate_add_patient_button_down() -> void:
	for element in state0_list_for_close:
		element.visible = false
	for element in state1_list_for_close:
		element.visible = false
	marcon_addpatient.visible = true
	pass # Replace with function body.


func _on_but_check_valid_polis_button_down() -> void:
	send_request_PATIENT_CHECK_STATUS()
	pass # Replace with function body.


func _on_but_open_check_valid_polis_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	marcon_checkvalidpolis.visible = true
	pass # Replace with function body.


func _on_but_open_get_snils_polis_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	marcon_getsnilspolis.visible = true
	pass # Replace with function body.



func _on_but_close_addit_menu_an_2_button_down() -> void:
	additmenu_openhistoryof.visible = false
	
	pass # Replace with function body.


func _on_but_get_snils_polis_button_down() -> void:
	send_request_PATIENT_GET_SNILS_POLIS()
	pass # Replace with function body.


func _on_but_set_hospital_button_down() -> void:
	patient_table.visible = false
	additmenu_openhistoryof.visible = false
	marcon_hospital.visible = true
	send_request_HOSPITAL_GET()
	pass # Replace with function body.

@onready var additmenu_sethspital = $MarCon_AdditMenu_SetHospital
func _on_but_close_addit_menu_set_hospital_button_down() -> void:
	additmenu_sethspital.visible = false
	pass # Replace with function body.
	


func _on_but_am_set_hospital_button_down() -> void:
	additmenu_sethspital.visible = false
	send_request_PATIENT_SET_HOSPITAL("hospital")
	pass # Replace with function body.


func _on_but_am_unset_hospital_button_down() -> void:
	additmenu_sethspital.visible = false
	send_request_PATIENT_SET_HOSPITAL("None")
	pass # Replace with function body.
