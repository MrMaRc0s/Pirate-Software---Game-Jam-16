class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var quit_button =  $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
@onready var start_level = preload("res://Scenes/world.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_start_pressed)
	quit_button.button_down.connect(on_quit_down)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)


func on_quit_down() -> void:
	get_tree().quit()
