tool


extends Panel


var url = "https://godot-chatapp-1-default-rtdb.firebaseio.com/messages.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Message_textEdit.rect_position.y = -($Message_textEdit.get_line_count() * $Message_textEdit.get_line_height()) + ($Message_textEdit.rect_min_size.y -20)
	$Message_textEdit.rect_size.y = $Message_textEdit.get_line_count() * $Message_textEdit.get_line_height() + 20
#	print($Message_textEdit.rect_size.y)


# run only in the game
	if not Engine.editor_hint:
		pass


func _on_Send_message_button_pressed():
	var Name = GlobalUser.name1
	var reg_no = GlobalUser.reg_no
	var message = $Message_textEdit.text
	var date = GlobalUser.datetime_to_string(OS.get_datetime())
	
	var data = {"Name":Name, "RegNo":reg_no, "Message":message, "DateTime":date}
	
	var error = $Send_message_request.request(url, [], true, HTTPClient.METHOD_POST, to_json(data))
	
	return


func _on_Send_message_request_request_completed(_result, _response_code, _headers, body):
	var response = parse_json(body.get_string_from_utf8())
#	print("****Sent response ", response)
	if response:
		$send_sfx.play()
		$Message_textEdit.text = "Message..."
#		$Message_textEdit.grab_focus()


func _on_Message_textEdit_focus_entered():
	print("_________focus")
	if $Message_textEdit.text == "Message...":
		print("whyyyy")
		yield(get_tree(), "idle_frame")
		$Message_textEdit.text = ""
