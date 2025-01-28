extends CharacterBody2D

@export var speed : int = 200  # Bullet speed
var direction : float  # Direction to move
var pos : Vector2  # Starting position

func _ready():
	global_position = pos  # Set initial position

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(direction)  # Move bullet forward
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):  # If the bullet hits the player
		body.take_damage(20)  # Deal damage to the player (adjust as needed)
		queue_free()  # Destroy the bullet
		print("bullet deleted")

	elif body.is_in_group("walls"):  # If it hits a wall, delete it
		queue_free()
		print("bullet deleted")
