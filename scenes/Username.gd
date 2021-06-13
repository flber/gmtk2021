extends Control

func _on_Continue_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_Back_pressed():
	get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")

func _on_Username_text_entered(new_text):
	GameState.username = new_text
