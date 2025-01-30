extends Node2D

var enemy = preload("res://Enemies/naturalKillerCell.tscn")

func _process(delta: float) -> void:
	if Global.boss:
		queue_free()

func spawn(pos: Vector2) -> void:
	var instance = enemy.instantiate()
	instance.position = pos
	add_child(instance)

func _on_timer_timeout() -> void:
	if Global.Kamikazi:
		spawn(Vector2(randf_range(-200, 1500), randf_range(-200, 1500)))
