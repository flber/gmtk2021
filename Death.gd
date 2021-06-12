extends Control
signal reset_rng
onready var score = $VBoxContainer/Score

#func _input(event):
#	if event.is_action_pressed("pause"):
#		unpause()

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


func _on_Chaser_death():
	toggle_pause()
	score.text = "You made it " + str(int(GameState.score/500)) + " meters!" \
	+"\nBest " + str(int(GameState.best_score/500)) + " meters."
	# todo ask for input, then save
	# todo show
	SilentWolf.Scores.persist_score("Ezra", GameState.score)
	SilentWolf.Scores.get_high_scores()
	print(SilentWolf.Scores.scores)
