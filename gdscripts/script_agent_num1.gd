extends Control

const DEFAULT_LIMIT = 10
const FONT_PATH = "res://font/Inter-VariableFont_opsz,wght.ttf"
@onready var but_activate_createstaffschedule = $VBoxContainer/MarCon_HighPanel/HBoxContainer/But_Activate_CreateStaffShedule
@onready var but_activate_createstructuremedicalinstitution = $VBoxContainer/MarCon_HighPanel/HBoxContainer/But_Activate_CreateStructureMedicalInstitution
@onready var But_activate_createreciptionschedule = $VBoxContainer/MarCon_HighPanel/HBoxContainer/But_Activate_CreateReciptionShedule


@onready var ob_selecthospital = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer/OB_SelectHospital
@onready var ob_selectbuilding = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer2/OB_SelectBuildng
@onready var ob_selectdepartment = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer3/OB_SelectDepartment

@onready var but_addhospital = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBC_Table_Rooms/HBoxContainer/But_AddHospital
@onready var but_addbuilding = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/But_AddBuilding

@onready var but_addroom = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/But_AddRoom

@onready var marcon_additmenu = $MarCon_AdditMenu
@onready var marcon_additmenu2 = $MarCon_AdditMenu2
@onready var label_additmenu_type = $MarCon_AdditMenu/VBoxContainer2/MarginContainer/HBoxContainer/Label
@onready var lineedit_name = $MarCon_AdditMenu/VBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/name
@onready var linedit_data_year = $MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer/year
@onready var linedit_data_month = $MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer/month
@onready var linedit_data_day = $MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer/day
@onready var but_changetodepartmentandroom = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/MarginContainer2/But_ChangeToDepartmentAndRoom

@onready var but_setroom = $MarCon_AdditMenu2/VBoxContainer/MarginContainer4/But_SetRoom
@onready var but_unplugroom = $MarCon_AdditMenu2/VBoxContainer/MarginContainer6/But_UnplugRoom

@onready var gridcon_people_lbls = $VBoxContainer/MarCon_Tables_RoomAndPeople/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels
@onready var gridcon_people_rects = $VBoxContainer/MarCon_Tables_RoomAndPeople/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects

@onready var b0 = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer/OB_SelectHospital
@onready var b1 = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer2/OB_SelectBuildng
@onready var b2 = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/VBoxContainer3/OB_SelectDepartment

@onready var structure_tables = $VBoxContainer/MarginContainer_StructureTables
@onready var structure_tabled_departmentroom = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom
@onready var marcon_selecthospitalbuildingdepartment = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment
@onready var marcon_tables_roomandpeople = $VBoxContainer/MarCon_Tables_RoomAndPeople

# БУФЕРНЫЕ ПЕРЕМЕННЫЕ ДЛЯ ПУТЕЙ
@onready var buf1 = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/GridCon_Hospital_Lbls
@onready var buf2 = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_Building_Lbls

@onready var buf3 =  $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/MarCon/GridCon_Hospital_Rects
@onready var buf4 = $VBoxContainer/MarginContainer_StructureTables/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_Rects_Building

@onready var buf_table_department_lbls = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/GridCon_Department_Lbls
@onready var buf_table_room_lbls = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_Room_Lbls

@onready var buf_table_department_rects = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/MarCon/GridCon_Department_Rects
@onready var buf_table_room_rects = $VBoxContainer/MarginContainer_StructureTables_DepartmentRoom/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_Room_Rects

@onready var bufgridcon_lbls = $VBoxContainer/MarCon_Tables_RoomAndPeople/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/GridCon_ForLabels
@onready var bufgridcon_rects = $VBoxContainer/MarCon_Tables_RoomAndPeople/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/MarCon/GridCon_ForColorRects

# STATE2
@onready var state2_first_window = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule
@onready var state2_second_window = $VBoxContainer/MarCon_Tables_ReceiptionSchedule


@onready var state2_employee_rects = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var state2_employee_lbls = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels

@onready var state2_schedule_rects = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/MarCon/GridCon_ForColorRects
@onready var state2_schedule_lbls = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/HBoxContainer/VBC_Table_Rooms/MarCon_Table_Rooms/GridCon_ForLabels

@onready var state2_reception_rects = $VBoxContainer/MarCon_Tables_ReceiptionSchedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var state2_reception_lbls = $VBoxContainer/MarCon_Tables_ReceiptionSchedule/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels


@onready var but_add_newworkday = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/But_AddNewWorkDay
@onready var but_open_schedule_window = $VBoxContainer/MarCon_Tables_EmployeeAndReceiptionShedule/VBoxContainer/But_OpenNextWindow
@onready var but_addworkday = $MarCon_AdditMenu3/VBoxContainer/MarginContainer3/But_MakeRequestToAddWorkDay


@onready var ob_selectworkshift = $MarCon_AdditMenu3/VBoxContainer/VBoxContainer/MarginContainer3/OB_SelectWorkShift
@onready var marcon_additmenu3 = $MarCon_AdditMenu3





var current_script_state = -1
var request_types = {}

var add_type:String
var current_selected_id_hospital = -2
var current_selected_id_building = -2
var current_selected_id_department = -2
var current_selected_id_room = -2
var current_selected_id_employee = -2


# STATE2
var state2_current_selected_id_employee = -2
var state2_current_selected_id_work = -2
var state2_current_selected_id_schedule = -2
var state2_current_reception_date: String = ""


func var_clearing():
	for state in dicts:
		for dict in dicts[state]:
			dicts[state][dict].clear()

	
	current_selected_id_hospital = -2
	current_selected_id_building = -2
	current_selected_id_department = -2
	current_selected_id_room = -2
	current_selected_id_employee = -2
	
	for request in request_types:
		request_types[request].queue_free()
	request_types.clear()
	
	current_rect = -1
	current_type = ""
	current_pos_for_request = -1
	for state in lbls:
		for element in lbls[state]:
			for lbl in lbls[state][element]:
				lbl.queue_free()
			lbls[state][element].clear()
	for state in rects:
		for element in rects[state]:
			for rect in rects[state][element]:
				rect.queue_free()
			rects[state][element].clear()
	for ob in obs:
		obs[ob].clear()

	lineedit_name.text = ""
	linedit_data_year.text = ""
	linedit_data_month.text = ""
	linedit_data_day.text = ""
	
	tmr_type = ""
	
	
func send_request_to_get_hospital():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/hospital/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "hospital/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_get_building():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/building/get?token={tkn}&id_hospital_for_search={id_hospital_for_search}"
	url = url.format({"tkn": gs.tkn, "id_hospital_for_search": current_selected_id_hospital})
	print("url get building:", url) 
	req.request(url)
	request_types[req] = "building/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
		
func send_request_to_get_department():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/department/get?token={tkn}&id_building_for_search={id_building_for_search}"
	url = url.format({"tkn": gs.tkn, "id_building_for_search": current_selected_id_building})
	print("url get department:", url)
	req.request(url)
	request_types[req] = "department/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_get_room():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/room/get?token={tkn}&id_department_for_search={id_department_for_search}"
	url = url.format({"tkn": gs.tkn, "id_department_for_search": current_selected_id_department})
	print("url get room:", url)
	req.request(url)
	request_types[req] = "room/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


func send_request_to_add_hospital():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/hospital/add"
	var data = {
		"token": gs.tkn, 
		"name": lineedit_name.text, 
		"data": linedit_data_year.text+"-"+linedit_data_month.text+"-"+linedit_data_day.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "hospital/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
	
func send_request_to_add_building():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/building/add"
	var data = {
		"token": gs.tkn,
		"id_hospital": current_selected_id_hospital,
		"name": lineedit_name.text, 
		"data": linedit_data_year.text+"-"+linedit_data_month.text+"-"+linedit_data_day.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "building/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))
	
func send_request_to_add_department():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/department/add"
	var data = {
		"token": gs.tkn,
		"id_building": current_selected_id_building,
		"name": lineedit_name.text, 
		"data": linedit_data_year.text+"-"+linedit_data_month.text+"-"+linedit_data_day.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "department/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_add_room():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/room/add"
	var data = {
		"token": gs.tkn,
		"id_department": current_selected_id_department,
		"name": lineedit_name.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "room/add"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


func send_request_to_get_post_info_employee():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee/get_post_info?token={tkn}".format({"tkn": gs.tkn})
	print("url get_post_info employee:", url)
	req.request(url)
	request_types[req] = "employee/get_post_info"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_get_with_count_room():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/room/get_with_count?token={tkn}&id_department_for_search={id_department_for_search}"
	url = url.format({"tkn": gs.tkn, "id_department_for_search": current_selected_id_department})
	print("url get_with_count room:", url)
	req.request(url)
	request_types[req] = "room/get_with_count"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


func send_request_to_set_employee_department(unplug:bool):
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee/set_workplace_department"
	var id_value
	
	if unplug:
		id_value = -1
	else:
		id_value = current_selected_id_department
	
	
	var data = {
		"token": gs.tkn,
		"id_employee": current_selected_id_employee,
		"id_department": id_value,
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "employee/set_workplace_department"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_set_employee_room(unplug:bool):
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee/set_workplace_room"
	var id_value
	
	if unplug:
		id_value = -1
	else:
		id_value = current_selected_id_room
	
	
	var data = {
		"token": gs.tkn,
		"id_employee": current_selected_id_employee,
		"id_room": id_value,
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "employee/set_workplace_room"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


func send_request_to_get_info_with_id_employee_schedule():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee_schedule/get_info_with_id?token={tkn}&id_employee={id_employee}".format({
		"tkn": gs.tkn, "id_employee": state2_current_selected_id_employee})
		
	print("url get_info_with_id employee_schedule:", url)
	req.request(url)
	request_types[req] = "employee_schedule/get_info_with_id"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

@onready var state2_lnedit_year = $MarCon_AdditMenu3/VBoxContainer/VBoxContainer/HBoxContainer/year
@onready var state2_lnedit_month = $MarCon_AdditMenu3/VBoxContainer/VBoxContainer/HBoxContainer/month
@onready var state2_lnedit_day = $MarCon_AdditMenu3/VBoxContainer/VBoxContainer/HBoxContainer/day
@onready var state2_lnedit_note = $MarCon_AdditMenu3/VBoxContainer/VBoxContainer/HBoxContainer2/Note
func send_request_to_employee_schedule_add_work_day():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/employee_schedule/add_work_day"
	var data = {
		"token": gs.tkn,
		"id_employee": state2_current_selected_id_employee,
		"id_work": state2_current_selected_id_work,
		"work_date" : state2_lnedit_year.text + "-" + state2_lnedit_month.text + "-" + state2_lnedit_day.text,
		"work_note" : state2_lnedit_note.text
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "employee_schedule/add_work_day"
	req.request_completed.connect(_on_http_request_request_completed.bind(req)) 


func send_request_to_work_shift_get():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/work_shift/get?token={tkn}".format({"tkn": gs.tkn})
	print("url get work_shift:", url)
	req.request(url)
	request_types[req] = "work_shift/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_to_reception_schedule_get():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/reception_schedule/get?token={tkn}&id_employee={id_employee}&reception_date={reception_date}".format({
		"tkn": gs.tkn,
		"id_employee": state2_current_selected_id_employee,
		"reception_date": state2_current_reception_date})
	print("url get reception_schedule:", url)
	req.request(url)
	request_types[req] = "reception_schedule/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))


@onready var state2_lineedit_patiendid = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer8/HBoxContainer2/PatientId
@onready var state2_ob_receptiontype = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer5/OB_SelectReceptionType
@onready var state2_lineedit_starttimehours = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer6/HBoxContainer/hours
@onready var state2_lineedit_starttimemins = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer6/HBoxContainer/mins
@onready var state2_lineedit_endtimehours = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer7/HBoxContainer/hours
@onready var state2_lineedit_endtimemins = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer7/HBoxContainer/mins
@onready var state2_reception_note = $MarCon_AdditMenu4/VBoxContainer/VBoxContainer/MarginContainer4/HBoxContainer2/Note

@onready var state2_addreception = $MarCon_AdditMenu4

func send_request_to_reception_schedule_add_reception():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/reception_schedule/add_reception"
	var data = {
		"token": gs.tkn,
		"id_employee": state2_current_selected_id_employee,
		"reception_type": state2_ob_receptiontype.get_item_text(state2_ob_receptiontype.selected),
		"reception_date": state2_current_reception_date,
		"start_time": state2_lineedit_starttimehours.text + ":" + state2_lineedit_starttimemins.text+ ":00",
		"end_time": state2_lineedit_endtimehours.text + ":" + state2_lineedit_endtimemins.text + ":00",
		"id_patient": int(state2_lineedit_patiendid.text),
		"reception_note": state2_reception_note.text,
		"status": "Not completed"  
	}
	print(data)
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "reception_schedule/add_reception"
	req.request_completed.connect(_on_http_request_request_completed.bind(req)) 


var dicts = {
	"state0":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": [],
		"employee": []
		
	},
	"state1":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": []
	},
	"state2":{
		"employee": [],
		"schedule": [],
		"work_shift": [],
		"reception": []}
}
	


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
			"hospital/get":
				print("hospital/get ", data)
				dicts["state0"]["hospital"] = data
				fill_ob("state0", "hospital")
			"building/get":
				print("building/get ", data)
				dicts["state0"]["building"] = data
				fill_ob("state0", "building")
			"department/get":
				print("department/get ", data)
				dicts["state0"]["department"] = data
				fill_ob("state0", "department")
			"room/get_with_count":
				print("room/get_with_count ", data)
				dicts["state0"]["room"] = data
				create_table("state0", "room")
			"employee/get_post_info":
				print("employee/get_post_info ", data)
				dicts["state0"]["employee"] = data
				create_table("state0", "employee")
			"employee/set_workplace_department":
				print("employee/set_workplace_department ", data)
				send_request_to_get_post_info_employee()
			"employee/set_workplace_room":
				print("employee/set_workplace_room ", data)
				send_request_to_get_with_count_room()
				send_request_to_get_post_info_employee()
				
	elif current_script_state == 1:
		match type:
			"hospital/get":
				print("hospital/get ", data)
				dicts["state1"]["hospital"] = data
				create_table("state1", "hospital")
				
				pass
			"building/get":
				print("building/get ", data)
				dicts["state1"]["building"] = data
				create_table("state1", "building")
				pass
			"department/get":
				print("department/get ", data)
				dicts["state1"]["department"] = data
				create_table("state1", "department")
				
				pass
			"room/get":
				print("room/get ", data)
				dicts["state1"]["room"] = data
				create_table("state1", "room")
				pass
			"hospital/add":
				print("hospital/add ", data["hospital/add"])
			"building/add":
				print("building/add ", data["building/add"])
			"department/add":
				print("department/add ", data["department/add"])
			"room/add":
				print("room/add ", data["room/add"])
	elif current_script_state == 2:
		match type:
			"employee/get_post_info":
				print("employee/get_post_info ", data)
				dicts["state2"]["employee"] = data
				create_table("state2", "employee")
			"employee_schedule/get_info_with_id":
				print("employee_schedule/get_info_with_id ", data)
				dicts["state2"]["schedule"] = data
				create_table("state2", "schedule")
			"work_shift/get":
				print("work_shift/get ", data)
				dicts["state2"]["work_shift"] = data
				for i in range(len(dicts["state2"]["work_shift"])):
					var st = str(dicts["state2"]["work_shift"][i]["work_type"]) + " " + str(dicts["state2"]["work_shift"][i]["start_time"]) + " " + str(dicts["state2"]["work_shift"][i]["end_time"])
					ob_selectworkshift.add_item(st)
			"employee_schedule/add_work_day":
				print("employee_schedule/add_work_day ", data["employee_schedule/add_work_day"])
				tmr_type = "state2_schedule"
				tmr.start(1)
			"reception_schedule/get":
				print("reception_schedule/get", data)
				dicts["state2"]["reception"] = data
				create_table("state2", "reception")

			"reception_schedule/add_reception":
				print("reception_schedule/add_reception", data["reception_schedule/add_reception"])
				tmr_type = "state2_reception"
				tmr.start(1)
			
				
			
	else:
		# НЕ ТРОГАТЬ
		pass
				
		
	request_types.erase(req)
	req.queue_free()


func _ready() -> void:
	pass
	
# ЗАПОЛНЕНИЕ ТАБЛИЦ
func make_label(text:String) -> Label:
	var lbl = Label.new()
	lbl.text = text
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

@onready var current_rect:int = -1
@onready var current_state:String =""
@onready var current_type:String = ""
@onready var current_pos_for_request:int = -1



var lbls = {
	"state0":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": [],
		"employee": []},
	"state1":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": []},
	"state2":{
		"employee": [],
		"schedule": [],
		"reception": []}
}

var rects = {
	"state0":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": [],
		"employee": []},
	"state1":{
		"hospital": [],
		"building": [],
		"department": [],
		"room": []},
	"state2":{
		"employee": [],
		"schedule": [],
		"reception": []}
}

# ПУТЬ К ТАБЛИЦАМ
# STATE2
@onready var state2_path_to_grid_lbls = {
	"state0":{
		"hospital": buf1,
		"building": buf2,
		"department": buf_table_department_lbls,
		"room": bufgridcon_lbls,
		"employee": gridcon_people_lbls},
	"state1":{
		"hospital": buf1,
		"building": buf2,
		"department": buf_table_department_lbls,
		"room": buf_table_room_lbls},
	"state2":{
		"employee": state2_employee_lbls,
		"schedule": state2_schedule_lbls,
		"reception": state2_reception_lbls}
}

@onready var state2_path_to_grid_rects = {
	"state0":{
		"hospital": buf3,
		"building": buf4,
		"department": buf_table_department_rects,
		"room": bufgridcon_rects,
		"employee": gridcon_people_rects},
	"state1":{
		"hospital": buf3,
		"building": buf4,
		"department": buf_table_department_rects,
		"room": buf_table_room_rects},
	"state2":{
		"employee": state2_employee_rects,
		"schedule": state2_schedule_rects,
		"reception": state2_reception_rects}
}


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



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("key_d"):
		print(request_types)
	if event.is_action_pressed("left_click"):
		if current_rect == -1:
			return
		
		# НАЖАТИЕ НА ТАБЛИЦЫ ПРИ STATE == 0
		if current_script_state == 0:
			if current_type == "room":
				var columns_count = 2
				var current_room = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state0")
				current_selected_id_room = dicts["state0"][current_type][current_room]["id_room"]
				but_setroom.disabled = false
				but_unplugroom.disabled = false
				print(current_selected_id_room)
			elif current_type == "employee":
				marcon_additmenu2.visible = true
				var current_employee = floorf(current_rect / 6)
				current_selected_id_employee = dicts["state0"][current_type][current_employee]["id"]
		# НАЖАТИЕ НА ТАБЛИЦЫ ПРИ STATE == 1
		elif current_script_state == 1:
			if current_type == "hospital":
				var columns_count = 2
				var current_hospital = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state1")
				
				current_selected_id_hospital = dicts["state1"][current_type][current_hospital]["id_hospital"]
				but_addbuilding.disabled = false
				send_request_to_get_building()
				but_changetodepartmentandroom.disabled = true
				current_selected_id_building = -2
			elif current_type == "building":
				var columns_count = 2
				var current_building = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state1")
				
				current_selected_id_building = dicts["state1"][current_type][current_building]["id_building"]
				but_changetodepartmentandroom.disabled = false
			
			elif current_type == "department":
				var columns_count = 2
				var current_department = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state1")
		
				current_selected_id_department = dicts["state1"][current_type][current_department]["id_department"]
				but_addroom.disabled = false
				but_open_schedule_window.disabled = true
				send_request_to_get_room()
				current_selected_id_room = -2
			pass
		# НАЖАТИЕ НА ТАБЛИЦЫ ПРИ STATE == 2
		elif current_script_state == 2:
			if current_type == "employee":
				var columns_count = 4
				var current_employee = floorf(current_rect / columns_count)
				
				keep_rect_highlighting(columns_count, "state2")
				
				state2_current_selected_id_employee = dicts["state2"][current_type][current_employee]["id"]
				send_request_to_get_info_with_id_employee_schedule()
				but_add_newworkday.disabled = false
			elif current_type == "schedule":
				var columns_count = 5
				var current_schedule = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state2")
				state2_current_selected_id_schedule = dicts["state2"][current_type][current_schedule]["id_schedule"]
				state2_current_reception_date = dicts["state2"][current_type][current_schedule]["work_date"]
				print(state2_current_selected_id_schedule)
				but_open_schedule_window.disabled = false
		else:
			pass
		
			
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
			"hospital": ["name", "date_foundation"],
			"building": ["name", "date_foundation"],
			"department": ["name", "date_foundation"],
			"room": ["name", "count_employees"],
			"employee": ["surname", "name", "middle_name", "post", "department_name", "room_name"]},
		"state1":{
			"hospital": ["name", "date_foundation"],
			"building": ["name", "date_foundation"],
			"department": ["name", "date_foundation"],
			"room": ["name"],
			"employee": ["surname", "name", "middle_name", "post", "department_name"]},
		"state2":{
			"employee": ["surname", "name", "middle_name", "post"],
			"schedule": ["work_date", "start_time", "end_time", "break_duration", "reception_count"],
			"reception": ["reception_type", "start_time", "end_time", "surname", "name", "middle_name", "reception_note", "status"]
			}
	}
	
	for i in range(len(dicts[state][type])):
		for field in fields[state][type]:
			var lbl = make_label(dicts[state][type][i][field])
			var rect = make_colrect(flag, pos, state, type, len(fields[state][type]))
			
			state2_path_to_grid_lbls[state][type].add_child(lbl)
			state2_path_to_grid_rects[state][type].add_child(rect)

			lbls[state][type].append(lbl)
			rects[state][type].append(rect)
			pos += 1
		flag = !flag



@onready var obs = {
"hospital": b0,
"building": b1,
"department": b2}


func fill_ob(state:String, type:String):
	for i in range(len(dicts[state][type])):
		obs[type].add_item(dicts[state][type][i]["name"])
	obs[type].select(-1)
	

func _on_but_activate_create_staff_shedule_button_down() -> void:
	var_clearing()
	current_script_state = 0
	but_changetoroomandpeople.disabled = true
	but_activate_createstaffschedule.disabled = true
	but_activate_createstructuremedicalinstitution.disabled = false
	But_activate_createreciptionschedule.disabled = false
	marcon_selecthospitalbuildingdepartment.visible = true
	
	structure_tables.visible = false
	structure_tabled_departmentroom.visible = false
	state2_second_window.visible = false
	state2_first_window.visible = false
	
	send_request_to_get_hospital()
	pass # Replace with function body.



func _on_but_activate_create_structure_medical_institution_button_down() -> void:
	var_clearing()
	current_script_state = 1
	but_activate_createstaffschedule.disabled = false
	but_activate_createstructuremedicalinstitution.disabled = true
	But_activate_createreciptionschedule.disabled = false
	
	marcon_selecthospitalbuildingdepartment.visible = false
	marcon_tables_roomandpeople.visible = false
	state2_second_window.visible = false
	state2_first_window.visible = false
	
	

	structure_tables.visible = true
	send_request_to_get_hospital()
	pass # Replace with function body.


func _on_but_add_hospital_button_down() -> void:
	marcon_additmenu.visible = true
	label_additmenu_type.text = "Добавить больницу"
	add_type = "hospital"
	pass # Replace with function body.

func _on_but_add_building_button_down() -> void:
	marcon_additmenu.visible = true
	var hospital_name = ""
	for i in range(len(dicts["state1"]["hospital"])):
		if dicts["state1"]["hospital"][i]["id_hospital"] == current_selected_id_hospital:
			hospital_name = dicts["state1"]["hospital"][i]["name"]
			break
	print(hospital_name)
	label_additmenu_type.text = "Добавить корпус к больнице {name}".format({"name": hospital_name})
	add_type = "building"
	pass # Replace with function body.

func _on_but_close_addit_menu_button_down() -> void:
	marcon_additmenu.visible = false
	pass # Replace with function body.

@onready var tmr = $Timer
var tmr_type:String = ""


func _on_but_make_request_to_add_all_button_down() -> void:
	$MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer.visible = true
	match add_type:
		"hospital":
			send_request_to_add_hospital()
			marcon_additmenu.visible = false
			tmr_type = "hospital"
			tmr.start(1)
		"building":
			send_request_to_add_building()
			marcon_additmenu.visible = false
			tmr_type = "building"
			tmr.start(1)
		"department":
			send_request_to_add_department()
			marcon_additmenu.visible = false
			tmr_type = "department"
			tmr.start(1)
			pass
		"room":
			send_request_to_add_room()
			marcon_additmenu.visible = false
			tmr_type = "room"
			tmr.start(1)
			
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	match tmr_type:
		"hospital":
			send_request_to_get_hospital()
		"building":
			send_request_to_get_building()
		"department":
			send_request_to_get_department()
		"room":
			send_request_to_get_room()
		"state2_schedule":
			send_request_to_get_info_with_id_employee_schedule()
		"state2_reception":
			send_request_to_reception_schedule_get()
	tmr.stop()
	pass # Replace with function body.



func _on_but_add_department_button_down() -> void:
	marcon_additmenu.visible = true
	label_additmenu_type.text = "Добавить отделение"
	add_type = "department"
	pass # Replace with function body.


func _on_but_change_to_department_and_room_button_down() -> void:
	structure_tables.visible = false
	structure_tabled_departmentroom.visible = true
	print(current_selected_id_building)
	send_request_to_get_department()
	
	pass # Replace with function body.


func _on_but_add_room_button_down() -> void:
	marcon_additmenu.visible = true
	label_additmenu_type.text = "Добавить кабинет"
	$MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer.visible = false
	add_type = "room"
	pass # Replace with function body.

func clear_department_and_room():
	var types = ["department", "room"]
	for type in types:
		for lbl in lbls["state1"][type]:
			lbl.queue_free()
		for rect in rects["state1"][type]:
			rect.queue_free()
		dicts["state1"][type].clear()
		lbls["state1"][type].clear()
		rects["state1"][type].clear()
	current_selected_id_department = -2
	current_selected_id_room = -2


	
func _on_but_change_back_to_hospital_building_button_down() -> void:
	clear_department_and_room()
	structure_tabled_departmentroom.visible = false
	structure_tables.visible = true
	but_addroom.disabled = true
	send_request_to_get_hospital()
	pass # Replace with function body.


func _on_ob_select_hospital_item_selected(index: int) -> void:
	but_changetoroomandpeople.disabled = true
	ob_selectbuilding.clear()
	ob_selectdepartment.clear()
	
	current_selected_id_hospital = dicts["state0"]["hospital"][ob_selecthospital.selected]["id_hospital"]
	print(current_selected_id_hospital)
	send_request_to_get_building()
	ob_selectbuilding.disabled = false
	pass # Replace with function body.


func _on_ob_select_buildng_item_selected(index: int) -> void:
	but_changetoroomandpeople.disabled = true
	ob_selectdepartment.clear()
	current_selected_id_building = dicts["state0"]["building"][ob_selectbuilding.selected]["id_building"]
	print(current_selected_id_building)
	send_request_to_get_department()
	ob_selectdepartment.disabled = false
	pass # Replace with function body.

@onready var but_changetoroomandpeople = $VBoxContainer/MarCon_SelectHospitalBuildingDepartment/VBoxContainer/But_ChangeToRoomAndPeople
func _on_ob_select_department_item_selected(index: int) -> void:
	current_selected_id_department = dicts["state0"]["department"][ob_selectdepartment.selected]["id_department"]
	print(current_selected_id_department)
	but_changetoroomandpeople.disabled = false
	pass # Replace with function body.


func _on_but_change_to_room_and_people_button_down() -> void:
	marcon_selecthospitalbuildingdepartment.visible = false
	marcon_tables_roomandpeople.visible = true
	send_request_to_get_post_info_employee()
	send_request_to_get_with_count_room()
	pass # Replace with function body.


func _on_but_return_to_hospital_building_department_button_down() -> void:
	marcon_selecthospitalbuildingdepartment.visible = true
	marcon_tables_roomandpeople.visible = false
	but_setroom.disabled = true
	but_unplugroom.disabled = true
	
	pass # Replace with function body.


func _on_but_close_addit_menu_2_button_down() -> void:
	marcon_additmenu2.visible = false
	pass # Replace with function body.



func _on_but_set_department_button_down() -> void:
	send_request_to_set_employee_department(false)
	pass # Replace with function body.


func _on_but_set_room_button_down() -> void:
	send_request_to_set_employee_room(false)
	pass # Replace with function body.


func _on_but_unplut_department_button_down() -> void:
	send_request_to_set_employee_department(true)
	pass # Replace with function body.


func _on_but_unplug_room_button_down() -> void:
	send_request_to_set_employee_room(true)
	pass # Replace with function body.


func _on_but_activate_create_reciption_shedule_button_down() -> void:
	var_clearing()
	current_script_state = 2
	but_activate_createstaffschedule.disabled = false
	but_activate_createstructuremedicalinstitution.disabled = false
	But_activate_createreciptionschedule.disabled = true
	structure_tables.visible = false
	structure_tabled_departmentroom.visible = false
	marcon_selecthospitalbuildingdepartment.visible = false
	marcon_tables_roomandpeople.visible = false
	state2_first_window.visible = true
	send_request_to_get_post_info_employee()
	pass # Replace with function body.


func _on_but_add_new_work_day_button_down() -> void:
	send_request_to_work_shift_get()
	marcon_additmenu3.visible = true
	pass # Replace with function body.


func _on_but_make_request_to_add_work_day_button_down() -> void:
	but_addworkday.disabled = true
	marcon_additmenu3.visible = false
	send_request_to_employee_schedule_add_work_day()
	pass # Replace with function body.

func _on_ob_select_work_shift_item_selected(index: int) -> void:
	state2_current_selected_id_work = dicts["state2"]["work_shift"][ob_selectworkshift.selected]["id_work"]
	but_addworkday.disabled = false
	pass # Replace with function body.


func _on_but_open_next_window_button_down() -> void:
	
	state2_first_window.visible = false
	state2_second_window.visible = true
	
	
	send_request_to_reception_schedule_get()
	pass # Replace with function body.


func _on_but_add_new_reception_button_down() -> void:
	state2_addreception.visible = true
	 
	pass # Replace with function body.


func _on_but_close_addit_menu_4_button_down() -> void:
	state2_addreception.visible = false
	pass # Replace with function body.


func _on_but_make_request_to_add_reception_button_down() -> void:
	state2_addreception.visible = false
	send_request_to_reception_schedule_add_reception()
	
	pass # Replace with function body.


func _on_but_go_back_button_down() -> void:
	state2_second_window.visible = false
	state2_first_window.visible = true
	pass # Replace with function body.
