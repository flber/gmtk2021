extends Control

onready var score = $VBoxContainer/Score

#func _input(event):
#	if event.is_action_pressed("pause"):
#		unpause()
		
func _on_Player_died():
	toggle_pause()

#	var text = ""
#	if GameState.level == 1:
#		text = "But you survived for at least a while, right?\n"
#	else:
#		text = "But you made it " + str(GameState.level) + " levels!\n"
#	score.text = text
#	GameState.level = 1

func _on_NewGameButton_pressed():
	toggle_pause()
	get_tree().reload_current_scene()

func _on_QuitToMenuButton_pressed():
	toggle_pause()
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")

func toggle_pause():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
