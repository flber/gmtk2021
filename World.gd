extends Node2D


const MAX_FROM_CENTER = 0.35


onready var cam := $Camera2D
onready var player := $Player
var scene = preload("res://GrapplePoint/GraplePoint.tscn")
var set_scene = preload("res://scenes/Set.tscn")
var highest = scene.instance()
var chase_speed = 60

var rng = RandomNumberGenerator.new()

var last_dash_at = 0
var highest_set_y := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	$Player.connect("start_dash", GameState, "on_dash")
	
	highest_set_y = get_node("Set").position.y
	
	rand_seed(hash(OS.get_system_time_msecs()))
	GameState.score = 0
	
	cam.position.x = 0
	
	
	player.position = Vector2.ZERO
	
	$Lbound.position.x = 2457 *-0.4
	$Rbound.position.x = 2457 *0.4
	
	highest.position.y -= 1440 *0.4
	
	self.add_child(highest)
	var btn = highest.get_node("Area2D")
	btn.connect("clicked_or_dragged_on", $Player, "_should_shoot_at", [highest.to_global(highest.get_node("Coli").position)])
	
	
	$Player.connect("start_dash", self, "on_dash")
	
	for i in range(10):
		var cur = set_scene.instance()
		cur.position.y = highest_set_y - 2951.92 # magic number
		highest_set_y = cur.position.y
		add_child(cur)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Chaser.get_node("Paw").position.x = player.position.x
	
	var gen_new = false
	cam.position.y = player.position.y
	while highest.position.y + 1440 * 2 > player.position.y:
		gen_new()
	
	#cam.zoom.x = (1+(-highest.position.y/10000))
	#cam.zoom.y = (1+(-highest.position.y/10000))

func gen_new():
	var new = scene.instance()
	new.position.y = highest.position.y + (rng.randf_range(-0.65 * 1440, -0.3 * 1440) )#* (1+(-highest.position.y/10000)))
	

	while is_equal_approx(new.position.x, highest.position.x):
		var rand_height_options = [rng.randf_range(-1000, -300), rng.randf_range(300, 1000)]
		new.position.x = highest.position.x + rand_height_options[randi() % 2]
		new.position.x = clamp(new.position.x, 2457 *-MAX_FROM_CENTER, 2457 * MAX_FROM_CENTER)
	
	var btn = new.get_node("Area2D")
	btn.connect("clicked_or_dragged_on", $Player, "_should_shoot_at", [new.to_global(new.get_node("Coli").position)])
	
	while highest_set_y > new.position.y:
		var cur = set_scene.instance()
		cur.position.y = highest_set_y - 2951.92 # magic number
		highest_set_y = cur.position.y
		add_child(cur)
	
	
	self.add_child(new)
	highest = new
	return new


func _physics_process(delta):
	GameState.score = max(GameState.score, -player.position.y)
	GameState.best_score = max(GameState.score, GameState.best_score)
	
	$Lbound.position.y = player.position.y
	$Rbound.position.y = player.position.y
	
	$Chaser.position.y = $Chaser.position.y - (chase_speed * delta)
	if last_dash_at + (1.4 * 1000) > OS.get_system_time_msecs():
		$Chaser.position.y = player.position.y + $Chaser.get_node("CollisionShape2D").get_shape().get_extents().y * 2
#	if !(last_dash_at + (3 * 1000) > OS.get_system_time_msecs()):
#		if player.position.y < -400:
#				$Chaser.position.y = 1481.18
#		
#		elif $Chaser.position.y > 0:
#			pass
#		else:
#			$Chaser.position.y = min(lerp($Chaser.position.y, player.position.y + 1440*2, 0.6), $Chaser.position.y)

	if player.position.y > -400:
		$Chaser.position.y = 1481.18 + 200
	
func on_dash():
	last_dash_at = OS.get_system_time_msecs()
	
