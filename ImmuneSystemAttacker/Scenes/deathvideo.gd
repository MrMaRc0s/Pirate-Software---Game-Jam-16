extends VideoStreamPlayer

func _ready():
	play()  # Force the video to start
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # "Space" or "Enter" by default
		skip_cinematic()

func _on_finished():
	skip_cinematic()

func skip_cinematic():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
