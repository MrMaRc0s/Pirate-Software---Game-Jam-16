extends Node2D

var enemy = preload("res://Enemies/macrophage.tscn")

func spawn(pos: Vector2) -> void:
	var instance = enemy.instantiate()
	instance.position = pos
	add_child(instance)

func _on_timer_timeout() -> void:
	spawn(Vector2(10, 10))
