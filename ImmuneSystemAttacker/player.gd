extends CharacterBody2D


const speed = 300.0
var face = false

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		face = true
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		face = false
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -speed
	else:
		velocity.x = 0
		velocity.y = 0
	play_anim()
	move_and_slide()

func play_anim():
	var anim = $AnimatedSprite2D
	anim.flip_h = face
	anim.play("default")
