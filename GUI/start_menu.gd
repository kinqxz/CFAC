extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/Options.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/Credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
