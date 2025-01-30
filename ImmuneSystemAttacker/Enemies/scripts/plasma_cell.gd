extends CharacterBody2D


@export var normalSpeed : int = 65
var SPEED : int = normalSpeed
@export var maxHealth : int = 300
var player
var health : int = maxHealth
var playerInRange : bool = false
var attackCooldown : bool = false
@export var dmg : int = 20
@export var xpDrop : int = 300
const projectile = preload("res://Scenes/projectile.tscn")

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
	if not attackCooldown and playerInRange:
		$AnimatedSprite2D.play("attack")
		fire()
		attackCooldown = true
		$AttackCooldown.start()

func fire():
	var bullet = projectile.instantiate()
	bullet.pos = global_position + Vector2(0, 8)
	bullet.direction = (player.position - position).angle() 
	get_parent().add_child(bullet)


func die():
	player.giveXp(xpDrop)
	queue_free()


func _on_attack_cooldown_timeout() -> void:
	attackCooldown = false
	
func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)


func _on_took_damage_timeout() -> void:
	$DisplayDmg.text = ""
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
