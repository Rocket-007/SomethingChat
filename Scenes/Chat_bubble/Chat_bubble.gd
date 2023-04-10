tool

extends Control


export(String, "left", "right", "non") var ARROW
export(String, "left", "right") var ALIGNMENT
export var Header = "~Obinna|201903019562"
export(String, MULTILINE) var Message
export var DateTime = "26/2/23    8:21 PM"

export var done_once_wrapping = false


onready var fade_anim = $Fade_in_animation

func _ready():
	fade_anim.play("chatB_fade_in")

class string_length_sorter:
	static func sort_ascending(a, b):
		if a.length() < b.length():
			return true
		return false
	static func sort_descending(a, b):
		if a.length() > b.length():
			return true
		return false


func _process(_delta):
	# Setting the arrow direction for the bubble
	if ARROW == "left":
		$arrow_left.show()
		$arrow_right.hide()
		$arrow_left.get_stylebox("panel", "").modulate_color = Color("202c33")
		
		var new_stylebox_normal = $Bubble_margin/Bubble.get_stylebox("panel").duplicate()
		new_stylebox_normal.bg_color = Color("202c33")
		$Bubble_margin/Bubble.add_stylebox_override("panel", new_stylebox_normal)
	elif ARROW == "right":
		$arrow_left.hide()
		$arrow_right.show()
		$arrow_right.get_stylebox("panel", "").modulate_color = Color("005c4b")
		
		var new_stylebox_normal = $Bubble_margin/Bubble.get_stylebox("panel").duplicate()
		new_stylebox_normal.bg_color = Color("005c4b")
		$Bubble_margin/Bubble.add_stylebox_override("panel", new_stylebox_normal)
	elif ARROW == "non":
		$arrow_left.hide()
		$arrow_right.hide()

	# Setting the Bubble Alignment
	if ALIGNMENT == "left":
		pass
	elif ALIGNMENT == "right":
		pass

	# Make the Chat bubble node grow according to the 
	# Message label node
	rect_size.y = $Bubble_margin/Bubble/Message.rect_size.y + $Bubble_margin/Bubble/Message.rect_position.y + $Bubble_margin.get_constant("margin_top") + ($Bubble_margin/Bubble/Header.rect_size.y * 2) + 15
#	rect_size.x = min($Bubble_margin/Bubble/Message.rect_position.x + ($Bubble_margin/Bubble/Message.rect_size.x) +  $Bubble_margin.get_constant("margin_left") + $Bubble_margin.get_constant("margin_right") + 25, 
#	550) # this number is what the size of Chatbubble will stop at when expanding cuz of Message

	# Inputs
	$Bubble_margin/Bubble/Header.text = Header
	$Bubble_margin/Bubble/Message.text = Message
	$Bubble_margin/Bubble/DateTime.text = DateTime

#	Get the length/size of the Longest line in Message
	var message_lines = $Bubble_margin/Bubble/Message.text.split("\n", true) as Array
	message_lines.sort_custom(string_length_sorter, "sort_descending")

#	Use the longest Line length to resize the chat bubble
	var max_characters = 90 
	var character_width = 7
	rect_size.x = min($Bubble_margin/Bubble/Message.rect_position.x + (character_width * max_characters),
	$Bubble_margin/Bubble/Message.rect_position.x + (character_width * message_lines[0].length()))

# run only in the game
	if not Engine.editor_hint:
		pass
