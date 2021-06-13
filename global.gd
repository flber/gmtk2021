extends Node

var score = 0
var has_died = false
var best_score = 0

func _ready():
	SilentWolf.configure({
		"api_key": "l2IKmos2jO5M6xQ6iac3s2rHWRc1YuxP94lj39lW",
		"game_id": "gmtk2021",
		"game_version": "1.0.0",
		"log_level": 0
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://TitleScreen/TitleScreen.tscn"
	})
	
