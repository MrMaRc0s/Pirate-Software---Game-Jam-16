extends CharacterBody2D

@export var speed : int = 200  # Bullet speed
var direction : float  # Direction to move
var pos : Vector2  # Starting position

func _ready():
	global_position = pos  # Set initial position
	rotation = direction  # Set rotation to match the direction
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(direction)  # Move bullet forward
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):  # If the bullet hits the player
		body.take_damage(25)  # Deal damage to the player (adjust as needed)
		queue_free()  # Destroy the bullet

	elif body.is_in_group("walls"):  # If it hits a wall, delete it
		queue_free()
