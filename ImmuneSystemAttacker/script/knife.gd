extends CharacterBody2D

@export var speed : int = 200  # Bullet speed
var direction: Vector2 = Vector2.ZERO
var pos : Vector2  # Starting position
@onready var sfx_knife_1: AudioStreamPlayer2D = $sfx_knife_1

func _ready():
	global_position = pos  # Set initial position
	#rotation = direction  # Set rotation to match the direction
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	if Global.ReverseKnife:
		$AnimatedSprite2D.play("reverse")
	else:
		$AnimatedSprite2D.play("default")
	if direction != Vector2.ZERO:
		velocity = direction * speed
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("takeDmg"):  # If the bullet hits the player
		body.takeDmg(Global.Dmg)  # Deal damage to the player
		queue_free()  # Destroy the bullet

	elif body.is_in_group("walls"):  # If it hits a wall, delete it
		queue_free()
