extends Control

@onready var optionsMenu = preload("res://Scenes/pause_menu.tscn")
func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	Global.pause = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	Global.pause = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _process(delta):
	testEsc()

func _on_button_pressed() -> void:
	resume()

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	
