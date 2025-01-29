extends Node2D

var neutrophils = preload("res://Enemies/neutrophils.tscn")
var naturalKillerCell = preload("res://Enemies/naturalKillerCell.tscn")



func spawn(pos: Vector2) -> void:
	randomize()
	var enemies = [neutrophils, naturalKillerCell]
	var enemy = enemies[randi()% enemies.size()]
	var instance = enemy.instantiate()
	instance.position = pos
	add_child(instance)

func _on_timer_timeout() -> void:
	if Global.naturalKillerCell:
		spawn(Vector2(randf_range(-200, 1500), randf_range(-200, 1500)))
