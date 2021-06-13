extends Node2D


onready var cam := $Camera2D
onready var player := $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	cam.position.x = get_viewport_rect().size.x * 0.5
	$GraplePoint/Button.connect("button_down", $Player, "_should_shoot_at", [$GraplePoint.position])
	$GraplePoint2/Button.connect("button_down", $Player, "_should_shoot_at", [$GraplePoint2.position])
	$GraplePoint3/Button.connect("button_down", $Player, "_should_shoot_at", [$GraplePoint3.position])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam.position.y = player.position.y
