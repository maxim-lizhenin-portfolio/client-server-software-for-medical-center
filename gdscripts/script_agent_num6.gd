extends Control

const DEFAULT_LIMIT = 10
const FONT_PATH = "res://font/Inter-VariableFont_opsz,wght.ttf"

@onready var But_activate_createreciptionschedule = $VBoxContainer/MarCon_HighPanel/HBoxContainer/But_Activate_CreateReciptionShedule


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
	
	tmr_type = ""
	

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

func send_request_PATIENT_ROOM_UPDATE(type: String):
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/update_room"
	var room
	if type == "None":
		room = "None"
	else:
		room = str(state3_current_selected_id_room)
	var data = {
		"token": gs.tkn,
		"id_patient": state3_current_selected_id_patient,
		"id_room": room
	}
	print(url)
	var json_body = JSON.stringify(data)
	var headers = []
	req.request(url, headers, HTTPClient.METHOD_POST, json_body)
	request_types[req] = "patient/update_room"
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


func send_request_PATIENT_GET():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/patient/get?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "patient/get"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))

func send_request_ROOM_GET_ALL():
	var req = HTTPRequest.new()
	add_child(req)
	var url = gs.MAIN_SOURCE + "/room/get_all?token={tkn}"
	url = url.format({"tkn": gs.tkn})
	req.request(url)
	request_types[req] = "room/get_all"
	req.request_completed.connect(_on_http_request_request_completed.bind(req))



var dicts = {
	"state2":{
		"employee": [],
		"schedule": [],
		"work_shift": [],
		"reception": []},
	"state3":{
		"patient": [],
		"room": []
	}
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
	
	if current_script_state == 2:
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
	elif current_script_state == 3:
		match type:
			"patient/get":
				print(type, data)
				dicts["state3"]["patient"] = data
				create_table("state3", "patient")
			"room/get_all":
				print(type, data)
				dicts["state3"]["room"] = data
				create_table("state3", "room")
		pass
			
				
			
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
	"state2":{
		"employee": [],
		"schedule": [],
		"reception": []},
	"state3":{
		"patient": [],
		"room": []
	}
}

var rects = {
	"state2":{
		"employee": [],
		"schedule": [],
		"reception": []},
	"state3":{
		"patient": [],
		"room": []
	}
}

@onready var state3_patient_lbls = $VBoxContainer/MarCon_Tables_Patient/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels
@onready var state3_patient_rects = $VBoxContainer/MarCon_Tables_Patient/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects
@onready var state3_room_lbls = $VBoxContainer/MarCon_Tables_Room/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/GridCon_ForLabels
@onready var state3_room_rects = $VBoxContainer/MarCon_Tables_Room/VBoxContainer/HBoxContainer/VBoxContainer2/MarCon_Table_People/MarCon/GridCon_ForColorRects


# ПУТЬ К ТАБЛИЦАМ
# STATE2
@onready var path_to_grid_lbls = {
	"state2":{
		"employee": state2_employee_lbls,
		"schedule": state2_schedule_lbls,
		"reception": state2_reception_lbls},
	"state3":{
		"patient": state3_patient_lbls,
		"room": state3_room_lbls
	}
}

@onready var path_to_grid_rects = {
	"state2":{
		"employee": state2_employee_rects,
		"schedule": state2_schedule_rects,
		"reception": state2_reception_rects},
	"state3":{
		"patient": state3_patient_rects,
		"room": state3_room_rects
	}
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

var state3_current_selected_id_patient: int = -2
var state3_current_selected_id_room: int = -2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if current_rect == -1:
			return

		# НАЖАТИЕ НА ТАБЛИЦЫ ПРИ STATE == 2
		if current_script_state == 2:
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
		elif current_script_state == 3:
			if current_type == "patient":
				var columns_count = 6
				var current_patient = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state3")
				state3_current_selected_id_patient = int(dicts["state3"][current_type][current_patient]["id_patient"])
				state3_additmenu5.visible = true
			elif current_type == "room":
				var columns_count = 4
				var current_room = floorf(current_rect / columns_count)
				keep_rect_highlighting(columns_count, "state3")
				state3_current_selected_id_room = dicts["state3"][current_type][current_room]["id_room"]
				state3_additmenuroom.visible = true
							
		else:
			pass
@onready var state3_additmenuroom = $MarCon_AdditMenu6	
			
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
		"state2":{
			"employee": ["surname", "name", "middle_name", "post"],
			"schedule": ["work_date", "start_time", "end_time", "break_duration", "reception_count"],
			"reception": ["reception_type", "start_time", "end_time", "surname", "name", "middle_name", "reception_note", "status"]
			},
		"state3":{
			"patient": ["surname", "name", "middle_name", "date_of_birth", "sex", "in_hospital"],
			"room": ["hospital_name", "building_name", "department_name", "room_name"]

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



@onready var tmr = $Timer
var tmr_type:String = ""


func _on_but_make_request_to_add_all_button_down() -> void:
	$MarCon_AdditMenu/VBoxContainer/VBoxContainer/HBoxContainer.visible = true
	match add_type:
		pass
			
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	match tmr_type:
		"state2_schedule":
			send_request_to_get_info_with_id_employee_schedule()
		"state2_reception":
			send_request_to_reception_schedule_get()
	tmr.stop()
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


func _on_but_activate_create_reciption_shedule_button_down() -> void:
	current_script_state = 2
	state2_first_window.visible = true
	send_request_to_get_post_info_employee()
	pass # Replace with function body.

@onready var state3_table_patient = $VBoxContainer/MarCon_Tables_Patient
@onready var state3_table_room = $VBoxContainer/MarCon_Tables_Room
@onready var state3_additmenu5 = $MarCon_AdditMenu5
@onready var state2_list_clear = [state2_first_window, state2_second_window, state2_addreception, marcon_additmenu3]
@onready var state3_list_clear = [state3_table_patient, state3_table_room, state3_additmenu5]




func _on_but_activate_register_patient_button_down() -> void:
	current_script_state = 3
	for element in state2_list_clear:
		element.visible = false
	state3_table_patient.visible = true
	send_request_PATIENT_GET()
	pass # Replace with function body.


func _on_but_open_set_room_button_down() -> void:
	state3_table_patient.visible = false
	state3_additmenu5.visible = false
	state3_table_room.visible = true
	send_request_ROOM_GET_ALL()
	pass # Replace with function body.


func _on_but_open_unset_room_button_down() -> void:
	send_request_PATIENT_ROOM_UPDATE("None")
	pass # Replace with function body.


func _on_but_set_room_button_down() -> void:
	send_request_PATIENT_ROOM_UPDATE("room")
	
	pass # Replace with function body.
