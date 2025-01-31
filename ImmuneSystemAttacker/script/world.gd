extends Node2D

signal toggle_game_paused(is_paused : bool)


var bossActive : bool = false
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		
		get_tree().paused = !game_paused
		emit_signal("toggle_game_paused", game_paused)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.pause == true:
		$CanvasLayer/PauseMenu.show()  # Show the pause menu
	else:
		$CanvasLayer/PauseMenu.hide()  # Hide the pause menu
	if Global.boss and not bossActive:
		bossActive=true
		var boss_scene = preload("res://Enemies/plasmaCell.tscn")
		var boss = boss_scene.instantiate() 
		boss.position = Vector2(500, 300) 
		get_parent().add_child(boss)
