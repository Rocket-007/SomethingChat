extends Node2D

var speed = 160
var angular_speed = 22
var _angle_change_timer = null


func _ready():
	# Create a timer to make the node change directions regularly
	_angle_change_timer = Timer.new()
	_angle_change_timer.set_wait_time(0.5)
	_angle_change_timer.set_one_shot(false)
	_angle_change_timer.connect("timeout", self, "_change_direction")
	add_child(_angle_change_timer)
	_angle_change_timer.start()

	_change_direction()


func _process(delta):
	# Rotate
	rotation = rotation + angular_speed * delta
	# Move
	var forward = angle_to_direction(rotation)
	position = position + forward * speed * delta


func _change_direction():
	angular_speed = rand_range(-PI, PI)


static func angle_to_direction(angle):
	return Vector2(cos(angle), -sin(angle))
