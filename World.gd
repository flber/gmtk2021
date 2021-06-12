extends Node2D


const MAX_FROM_CENTER = 0.35


onready var cam := $Camera2D
onready var player := $Player
var scene = preload("res://GrapplePoint/GraplePoint.tscn")

var highest = scene.instance()

var rng = RandomNumberGenerator.new()

var last_dash_at = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_seed(hash(OS.get_system_time_msecs()))
	GameState.score = 0
	
	cam.position.x = 0
	
	
	$Lbound.position.x = get_viewport().size.x *-0.4
	$Rbound.position.x = get_viewport().size.x *0.4
	
	highest.position.y -= get_viewport().size.y *0.4
	
	self.add_child(highest)
	var btn = highest.get_node("Area2D")
	btn.connect("clicked_or_dragged_on", $Player, "_should_shoot_at", [highest.to_global(highest.get_node("Coli").position)])
	
	
	$Player.connect("start_dash", self, "on_dash")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gen_new = false
	cam.position.y = player.position.y
	while highest.position.y + get_viewport().size.y * 2 > player.position.y:
		gen_new()
	
	#cam.zoom.x = (1+(-highest.position.y/10000))
	#cam.zoom.y = (1+(-highest.position.y/10000))
	


func gen_new():
	var new = scene.instance()
	new.position.y = highest.position.y + (rng.randf_range(-0.65 * get_viewport().size.y, -0.3 * get_viewport().size.y) )#* (1+(-highest.position.y/10000)))
	
	
	while is_equal_approx(new.position.x, highest.position.x):
		new.position.x = highest.position.x + [rng.randf_range(-1000, -300), rng.randf_range(300, 1000)][randi() % 2]
		new.position.x = clamp(new.position.x, get_viewport().size.x *-MAX_FROM_CENTER, get_viewport().size.x * MAX_FROM_CENTER)
	
	var btn = new.get_node("Area2D")
	btn.connect("clicked_or_dragged_on", $Player, "_should_shoot_at", [new.to_global(new.get_node("Coli").position)])
	
	self.add_child(new)
	highest = new
	return new


func _physics_process(delta):
	
	GameState.score = max(GameState.score, -player.position.y)
	GameState.best_score = max(GameState.score, GameState.best_score)
	
	$Lbound.position.y = player.position.y
	$Rbound.position.y = player.position.y
	
	if !(last_dash_at + (3 * 1000) > OS.get_system_time_msecs()):
		$Chaser.position.y = min(lerp($Chaser.position.y, player.position.y + get_viewport().size.y*2, 0.6), $Chaser.position.y)

func on_dash():
	last_dash_at = OS.get_system_time_msecs()
	
