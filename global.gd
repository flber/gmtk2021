extends Node

var username = "user"
var score = 0
var has_died = false
var best_score = 0
var count = 0
var textures = []
var last_dash_at = 0
func _ready():
	SilentWolf.configure({
		"api_key": "l2IKmos2jO5M6xQ6iac3s2rHWRc1YuxP94lj39lW",
		"game_id": "gmtk2021",
		"game_version": "1.1.0",
		"log_level": 0
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://TitleScreen/TitleScreen.tscn"
	})


	SilentWolf.Scores.get_high_scores()
	
	for i in range(1, 121):
		textures.append(load("res://assets/loadingtexture/lt"+ str(i) +".png"))


func to_res_independant(val):
	return val * (get_viewport().size.y/1440)
	return val * (get_viewport().size.y/1440)

func on_dash():
	last_dash_at = OS.get_system_time_msecs()

func _process(delta):
	var frame = ((OS.get_system_time_msecs() - last_dash_at)/1000.0/5.0) * 120
	frame = clamp(frame, 0, 119)
	Input.set_custom_mouse_cursor(textures[frame], 0, Vector2(256/2, 256/2))
