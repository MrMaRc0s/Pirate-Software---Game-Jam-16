extends CharacterBody2D

var pos : Vector2
var direction : float
var speed : int = 200

func _ready() -> void:
	global_position=pos
	$AnimatedSprite2D.play("default")
	
func _physics_process(delta: float) -> void:
	velocity=Vector2(speed,0).rotated(direction)
	move_and_slide()
