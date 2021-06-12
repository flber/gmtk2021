extends Area2D

signal clicked_or_dragged_on

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update()
	var re2 = Rect2(position - get_child(0).shape.extents, get_child(0).shape.extents * 2)
	if Input.is_mouse_button_pressed(1) and re2.has_point(to_local(get_global_mouse_position())):
		emit_signal("clicked_or_dragged_on")
		print(OS.get_system_time_msecs())
