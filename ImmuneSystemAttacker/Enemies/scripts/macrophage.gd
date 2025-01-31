extends CharacterBody2D


@export var normalSpeed : int = 60
var SPEED : int = normalSpeed
@export var maxHealth : int = 50
var player
var health : int = maxHealth
var playerInRange : bool = false
var attackCooldown : bool = false
@export var dmg : int = 10
@export var xpDrop : int = 200
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assign the first found player
	else:
		print("ERROR: Player not found!")
	$AnimatedSprite2D.play("default")
	$DisplayDmg.text = ""

func takeDmg(amount: int):
	health -= amount
	$DisplayDmg.text = "-"+str(amount)
	turn_red()
	if health <= 0:
		die()

func turn_red():
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	$tookDamage.start(0.3)

func enemy():
	pass


func _physics_process(_delta):
	updateHealthbar()
	attackPlayer()
	if Global.PlayerAlive:
		$AnimatedSprite2D.flip_h = (player.position.x < position.x)
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		SPEED = 0
		playerInRange = true
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		SPEED = normalSpeed
		playerInRange = false
		$AnimatedSprite2D.play("default")
		
func attackPlayer():
	if playerInRange:
		$AnimatedSprite2D.play("attack")
	

func die():
	player.giveXp(xpDrop)
	queue_free()
	
func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)


func _on_took_damage_timeout() -> void:
	$DisplayDmg.text = ""
	$AnimatedSprite2D.modulate = Color(1, 1, 1)


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 3:
		player.take_damage(dmg)
		audio_stream_player_2d.play()
