extends MarginContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ctrl+x"):
		if gs.is_admin == true:
			if visible == true:
				visible = false
			else:
				visible = true


func _on_but_change_scene_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.


func _on_but_change_scene_2_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num0.tscn")
	pass # Replace with function body.


func _on_but_change_scene_3_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num1.tscn")
	pass # Replace with function body.


func _on_but_change_scene_4_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num2.tscn")
	pass # Replace with function body.


func _on_but_change_scene_5_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num3.tscn")
	pass # Replace with function body.


func _on_but_change_scene_6_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num4.tscn")
	pass # Replace with function body.


func _on_but_change_scene_7_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num5.tscn")
	pass # Replace with function body.


func _on_but_change_scene_8_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/agent_num6.tscn")
	pass # Replace with function body.
