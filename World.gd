extends Node2D


onready var cam := $Camera2D
onready var player := $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	cam.position.x = get_viewport_rect().size.x * 0.5
	for btn in get_tree().get_nodes_in_group("grapple_target_buttons"):
		btn.connect("button_down", $Player, "_should_shoot_at", [btn.get_pos()])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam.position.y = player.position.y
