extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()


func _on_QuitToMenuButton_pressed():
	toggle_pause()
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")


func _on_ResumeButton_pressed():
	toggle_pause()

func toggle_pause():
	if !GameState.has_died:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
