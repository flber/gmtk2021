extends Camera2D

export var decay = 1.5
export var power = 2

var max_angle = 5
var max_offset = Vector2(10, 10)

var trauma = 0

onready var noise = OpenSimplexNoise.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	noise.period = 4
	noise.octaves = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trauma -= decay * delta
	trauma = max(trauma, 0)
	shake()

func shake():
	var amount = pow(trauma, power)
	rotation = max_angle * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)


func _on_Player_start_dash():
	trauma += 1
	trauma = clamp(trauma, 0, 1)
