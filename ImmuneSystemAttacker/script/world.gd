extends Node2D

var bossActive : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
