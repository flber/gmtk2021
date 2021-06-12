extends Area2D
signal death

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Chaser_body_shape_entered(body_id, body, body_shape, local_shape):
	emit_signal("death")

func _physics_process(delta):
	position.y -= 6
