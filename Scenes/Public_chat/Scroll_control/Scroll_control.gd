tool

extends Control


# Declare member variables here. Examples:
var Chat_bubble = load("res://Scenes/Chat_bubble/Chat_bubble.tscn")



#{"DateTime":"2023/03/9 14:14", "Message":"", "Name":"???", "RegNo":'???"}

var local_messages = [
#	{"name" : "obinna","regNo":"2019", "message":"idkk", "date":GlobalUser.datetime_to_string(OS.get_datetime())},
	{"name" : "obinna","regNo":"2019030190562", "message":"idkk", "date":GlobalUser.datetime_to_string(OS.get_datetime())},
	{"name" : "obinna","regNo":"2019030190562", "message":"dskdljfkln  Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.", "date":GlobalUser.datetime_to_string(OS.get_datetime())},
	{"name" : "obinna","regNo":"2019", "message":"idkk", "date":GlobalUser.datetime_to_string(OS.get_datetime())},
	]
	

func _ready():
# run only in the game
	if not Engine.editor_hint:
		for v in get_children():
			v.queue_free()
		
#		Some Local Messages Here !!!!!
		return ##########
		for v in local_messages:
			var chat_bubble = Chat_bubble.instance()
			chat_bubble.Header = v.name +"|"+ v.regNo
			chat_bubble.Message = v.message
			chat_bubble.DateTime = v.date
			
			add_child(chat_bubble)

			if v.regNo == GlobalUser.reg_no:
				chat_bubble.ARROW = "right"
				yield(get_tree(), "idle_frame")
				chat_bubble.rect_position.x = (get_parent().rect_position.x + get_parent().rect_size.x) - chat_bubble.rect_size.x
		
		

#	print(GlobalUser.reg_no)


func _process(_delta):
	# Lost Responsiveness of control node
	# Follow the parents own Width
	rect_size.x = get_parent().rect_size.x

	# Stacking the children by order
	for v in get_children():
		if v.get_index() > 0:
			v.rect_position.y = get_child(v.get_index()-1).rect_position.y + get_child(v.get_index()-1).rect_size.y 
		
	if get_child_count() != 0:
		rect_min_size.y = get_child(get_child_count()-1).rect_position.y + get_child(get_child_count()-1).rect_size.y 
	
# run only in the game
	if not Engine.editor_hint:
#		Stacking the children by order when running the game just in case
		for v in get_children():
			if v.get_index() > 0:
				v.rect_position.y = get_child(v.get_index()-1).rect_position.y + get_child(v.get_index()-1).rect_size.y 

		
#		Virtual KeyBoard Stuff
		if OS.has_virtual_keyboard():
			if OS.get_virtual_keyboard_height() != 0 and OS.get_virtual_keyboard_height() > -1:
				 get_parent().get_parent().rect_min_size.y = 1110 - OS.get_virtual_keyboard_height() - 15
			else:
				 get_parent().get_parent().rect_min_size.y = 1110
			
