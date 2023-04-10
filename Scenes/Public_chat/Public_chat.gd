extends Control



onready var scroll_control = $VBoxContainer/Panel2/ScrollContainer/Scroll_control

var Chat_bubble = load("res://Scenes/Chat_bubble/Chat_bubble.tscn")
var url = "https://godot-chatapp-1-default-rtdb.firebaseio.com/messages.json"



func _ready():
	var error = $Content_request.request(url)
	if error != OK:
		pass
	

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("reload"):
			get_tree().reload_current_scene()


func add_chat_bubbles(response):
	for v in response.values():
		var chat_bubble = Chat_bubble.instance()
		
		if v.has("Name") and v.has("RegNo"):
			chat_bubble.Header = v.Name +"|"+ v.RegNo
		elif v.has("Name"):
			chat_bubble.Header = v.Name +"|"+ "???????????"
		elif v.has("RegNo"):
			chat_bubble.Header = "???????" +"|"+ v.RegNo
		else:
			chat_bubble.Header = "???????" +"|"+ "???????????"
		
		if v.has("Message"):
			chat_bubble.Message = v.Message
		else:
			chat_bubble.Message = "Unknown Response"
		
		if v.has("DateTime"):
			chat_bubble.DateTime = v.DateTime
		else:
			chat_bubble.DateTime = "????/??/?? ??:??"
		
		scroll_control.add_child(chat_bubble)

		if v.has("RegNo"):
			if v.RegNo == GlobalUser.reg_no:
				chat_bubble.ARROW = "right"
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")
				chat_bubble.rect_position.x = (scroll_control.rect_position.x + scroll_control.rect_size.x) - chat_bubble.rect_size.x


func _on_Content_request_request_completed(_result, _response_code, _headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print("----Readdy response ", response)
	GlobalUser.local_response = response

	if response:
		add_chat_bubbles(response)
		# GOOOD right? response retrieved?
	var error = $Content_stream_request.request(url)#$Content_stream_request.request("https://godot-chatapp-1-default-rtdb.firebaseio.com/test.json", ["Content-Type: text/event-stream"])
	if error != OK:
		pass


func differenciate_table(table1, table2):
	var new_table = {}
	if table1 and table2:
		for v in table1.keys():
			if table2.has(v):
	#			print(v)
				pass
			else:
				new_table[v] = table1[v]
		
		return new_table


func _on_Content_stream_request_request_completed(_result, _response_code, _headers, body):
#	print(headers)
	var response = parse_json(body.get_string_from_utf8())
	var new_response = differenciate_table(response, GlobalUser.local_response)
#	print("---response normal ", response)
#	print("---response Diff", new_response)
	
	if new_response == null and (is_instance_valid(response) or response):
		add_chat_bubbles(response)
		GlobalUser.local_response = response
	
	if new_response:
		print("content refreshing if any")
		add_chat_bubbles(new_response)
		
		GlobalUser.local_response = response

	var error = $Content_stream_request.request(url)
	if error != OK:
		pass


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Login/Login.tscn")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows
		get_tree().change_scene("res://Scenes/Login/Login.tscn")

	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# For Android
		get_tree().change_scene("res://Scenes/Login/Login.tscn")
