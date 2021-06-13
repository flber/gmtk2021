extends Control
signal reset_rng
onready var score = $Full/UI/LevelButtons/Score

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
	score.text = "You made it " + str(int(GameState.score/500)) + " meters!" \
	+"\nBest " + str(int(GameState.best_score/500)) + " meters."
	# todo ask for input, then save
	# todo show
	SilentWolf.Scores.persist_score("Ezra", GameState.score)
	SilentWolf.Scores.get_high_scores()
	var scores = SilentWolf.Scores.scores
	print("!! scores !!")
	if len(scores) > 3:
		var val1 = (scores[0]["player_name"] + ": " + str(int(scores[0]["score"]/500)))
		$Full/UI/HighScores/Score1 .text = val1
		var val2 = (scores[1]["player_name"] + ": " + str(int(scores[1]["score"]/500)))
		$Full/UI/HighScores/Score2.text = val2
		var val3 = (scores[2]["player_name"] + ": " + str(int(scores[2]["score"]/500)))
		$Full/UI/HighScores/Score3.text = val3

