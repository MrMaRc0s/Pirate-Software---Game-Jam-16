extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/player.tscn")

func _on_wiki_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	
