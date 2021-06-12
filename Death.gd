extends Control

onready var score = $VBoxContainer/Score

#func _input(event):
#	if event.is_action_pressed("pause"):
#		unpause()

func _on_NewGameButton_pressed():
	toggle_pause()
	GameState.has_died = false
	get_tree().reload_current_scene()

func _on_QuitToMenuButton_pressed():
	toggle_pause()
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")

func toggle_pause():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_Chaser_death():
	toggle_pause()
	GameState.has_died = true
	score.text = "You made it " + str(int(GameState.score/500)) + " meters!"
