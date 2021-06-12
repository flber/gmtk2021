extends Node2D


const MAX_FROM_CENTER = 0.35


onready var cam := $Camera2D
onready var player := $Player
var scene = preload("res://GrapplePoint/GraplePoint.tscn")

var highest = scene.instance()

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rand_seed(17)
	rng = RandomNumberGenerator.new()
	
	
	cam.position.x = 0
	
	
	$Lbound.position.x = get_viewport().size.x *-0.5 + 200
	$Rbound.position.x = get_viewport().size.x *0.5 - 200
	
	self.add_child(highest)
	var btn = highest.get_node("Area2D")
	btn.connect("mouse_entered", $Player, "_should_shoot_at", [btn.get_parent().position])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gen_new = false
	cam.position.y = player.position.y
	while highest.position.y + get_viewport().size.y * 2 > player.position.y:
		gen_new()


func gen_new():
	var new = scene.instance()
	new.position.y = highest.position.y + rng.randf_range(-0.65 * get_viewport().size.y, -0.3 * get_viewport().size.y)
	
	
	while is_equal_approx(new.position.x, highest.position.x):
		new.position.x = highest.position.x + [rng.randf_range(-900, -300), rng.randf_range(300, 900)][randi() % 2]
		new.position.x = clamp(new.position.x, get_viewport().size.x *-MAX_FROM_CENTER, get_viewport().size.x * MAX_FROM_CENTER)
	
	var btn = new.get_node("Area2D")
	btn.connect("button_down", $Player, "_should_shoot_at", [btn.get_parent().position])
	
	self.add_child(new)
	highest = new
	return new


func _physics_process(delta):
	$Lbound.position.y = player.position.y
	$Rbound.position.y = player.position.y
