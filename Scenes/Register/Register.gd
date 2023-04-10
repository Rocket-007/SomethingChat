extends Control


var url = "https://godot-chatapp-1-default-rtdb.firebaseio.com/users.json"

#var local_dict = {}
#var username = ""

func _ready():
	$Credentials_animation.play("credencials_fade_in")
	
	yield(get_tree().create_timer(0.3), "timeout")
	$Logo_animation.play("logo_fade_in")
	yield(get_tree().create_timer(0.5), "timeout")
	$Button_animation.play("login_button_fade_in")
	
	yield(get_tree().create_timer(0.4), "timeout")
	$Logo_animation.play("logo_lable_floating")


func _process(_delta):
#	Virtual KeyBoard Stuff
	if OS.has_virtual_keyboard():
		if OS.get_virtual_keyboard_height() != 0 and OS.get_virtual_keyboard_height() > -1: # and $RegNo_lineEdit.has_focus():
			var reduced = 220
#			$Register_label.rect_position.y = 400 - reduced + 70
			$Register_label.hide()
			
			$RegNo_label.rect_position.y = 494.5 - reduced
			$RegNo_lineEdit.rect_position.y = 544.5 - reduced
			
			$Name_label.rect_position.y = 632.5 - reduced
			$Name_lineEdit.rect_position.y = 682 - reduced
			
			$Password_label.rect_position.y = 780 - reduced
			$Password_lineEdit.rect_position.y = 830 - reduced
#			 get_parent().get_parent().rect_min_size.y = 1110 - OS.get_virtual_keyboard_height() #- 100
		else:
#			$Register_label.rect_position.y = 400
			$Register_label.show()
			
			$RegNo_label.rect_position.y = 494.5
			$RegNo_lineEdit.rect_position.y = 544.5
			
			$Name_label.rect_position.y = 632.5
			$Name_lineEdit.rect_position.y = 682
			
			$Password_label.rect_position.y = 780
			$Password_lineEdit.rect_position.y = 830


func _input(event):
#	return
	if event is InputEventKey:
		if event.is_action_pressed("reload"):
			get_tree().reload_current_scene()


func _on_RegNo_lineEdit_focus_entered():
	$LineEdit_animation.play("reg_active")
	pass


func _on_Name_lineEdit_focus_entered():
	$LineEdit_animation.play("name_active")
	

func _on_Password_lineEdit_focus_entered():
	$LineEdit_animation.play("pwd_active")


func _on_Login_button_pressed():
	# Send a request for users
	var error = $Login_request.request(url)
	if error != OK:
#		push_error("An error occurred in the HTTP request.")
		$Notification_label.text ="" #"An error occurred in the HTTP request."





func _on_Have_acc_button_pressed():
	get_tree().change_scene("res://Scenes/Login/Login.tscn")


func _on_Contact_button_pressed():
	OS.shell_open("https://rocket-007.itch.io/somethingchat")


func register_self():
	var Name = $Name_lineEdit.text
	var reg_no = $RegNo_lineEdit.text
	var password = $Password_lineEdit.text
	
	var date = GlobalUser.datetime_to_string(OS.get_datetime())
	var registered_device = OS.get_model_name()
	
	var data = {"Name":Name, "RegNo":reg_no, "Password":password, "TimeCreated":date, "RegisteredDevice":registered_device}
	
	var error = $Register_request.request(url, [], true, HTTPClient.METHOD_POST, to_json(data))


func _on_Register_request_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
#	print("****Sent response ", response)


func _on_Register_button_pressed():
	var error = $Existing_users_request.request(url)


func _on_Existing_users_request_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
#	print("----------------------------------------------")
#	print("Existing users ",response)
#	print("----------------------------------------------")
	
	if response:
#		print(response.keys())
		for v in response.values():
			if v.has("RegNo"):
				if v.RegNo == $RegNo_lineEdit.text:
					$Notification_label.show()
					$Notification_label.text = "Registeration Number already exists in database."
					yield(get_tree().create_timer(1.5), "timeout")
					$Notification_label.hide()
					print("came here")
#					break
					return
#					continue
				if v.RegNo != $RegNo_lineEdit.text:
					continue
					
		register_self()
		
		$Notification_label.show()
		$Notification_label.text = "Registeration successful."
		yield(get_tree().create_timer(2), "timeout")
		$Notification_label.hide()
	
	else:
		$Notification_label.show()
		$Notification_label.text = "No response from server"
		yield(get_tree().create_timer(1.5), "timeout")
		$Notification_label.hide()


func _on_Back_button_pressed():
	get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows
		get_tree().quit()

	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# For Android
		get_tree().quit()
