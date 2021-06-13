extends Node

onready var cam := $Camera2D
onready var actual := $KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam.position.y = actual.position.y
