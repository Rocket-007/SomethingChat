extends Control


#var url = "https://json.extendsclass.com/bin/71f04303054a"
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


func _input(event):
#	return
	if event is InputEventKey:
		if event.is_action_pressed("reload"):
			get_tree().reload_current_scene()


func _on_RegNo_lineEdit_focus_entered():
	$LineEdit_animation.play("reg_active")
	pass


func _on_Password_lineEdit_focus_entered():
	$LineEdit_animation.play("pwd_active")


func _on_Login_button_pressed():
	# Send a request for users
	var error = $Login_request.request(url)
	if error != OK:
#		push_error("An error occurred in the HTTP request.")
		$Notification_label.text ="" #"An error occurred in the HTTP request."


func _on_Login_request_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
#	print(response)

	if response:
		for v in response.values():
			if v.has("RegNo") and v.has("Password"):
				if v.RegNo == ($RegNo_lineEdit.text):
					if $Password_lineEdit.text == v.Password:
						$Notification_label.text = "Login successful"
						
						GlobalUser.reg_no = $RegNo_lineEdit.text
						GlobalUser.name1 = v.Name
						
						$Welcome_label/info_label.text = GlobalUser.name1
						
						$Scene_trans_animation.play("fade_out")
						$Credentials_animation.play("name_info_fade_in")
						yield(get_tree().create_timer(1), "timeout")
						
						get_tree().change_scene("res://Scenes/Public_chat/Public_chat.tscn")
					
					else:
						$Notification_label.show()
						$Notification_label.text = "Incorrect password for User"
						yield(get_tree().create_timer(1.5), "timeout")
						$Notification_label.hide()
						
					return
					
		$Notification_label.show()
		$Notification_label.text = "User Registeration Number not found"
		yield(get_tree().create_timer(1.5), "timeout")
		$Notification_label.hide()
		
	else:
		$Notification_label.show()
		$Notification_label.text = "No response from server"
		yield(get_tree().create_timer(1.5), "timeout")
		$Notification_label.hide()


func _process(_delta):
#	Virtual KeyBoard Stuff
	if OS.has_virtual_keyboard():
		if OS.get_virtual_keyboard_height() != 0 and OS.get_virtual_keyboard_height() > -1: # and $RegNo_lineEdit.has_focus():
			var reduced = 200
			$Login_label.rect_position.y = 432 - reduced + 70
			
			$RegNo_label.rect_position.y = 564.5 - reduced
			$RegNo_lineEdit.rect_position.y = 624 - reduced
			
			$Password_label.rect_position.y = 732.5 - reduced
			$Password_lineEdit.rect_position.y = 792 - reduced
#			 get_parent().get_parent().rect_min_size.y = 1110 - OS.get_virtual_keyboard_height() #- 100
			print(OS.get_virtual_keyboard_height())
		else:
			$Login_label.rect_position.y = 432
			
			$RegNo_label.rect_position.y = 564.5
			$RegNo_lineEdit.rect_position.y = 624
			
			$Password_label.rect_position.y = 732.5
			$Password_lineEdit.rect_position.y = 792


func _on_Back_button_pressed():
	get_tree().change_scene("res://Scenes/Register/Register.tscn")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows
		get_tree().change_scene("res://Scenes/Register/Register.tscn")

	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# For Android
		get_tree().change_scene("res://Scenes/Register/Register.tscn")


func _on_Contact_button_pressed():
	OS.shell_open("https://rocket-007.itch.io/somethingchat")
