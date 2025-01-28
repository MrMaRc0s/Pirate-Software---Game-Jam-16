extends CharacterBody2D


@export var normalSpeed : int = 65
var SPEED : int = normalSpeed
@export var maxHealth : int = 20
var player
var health : int = maxHealth
var playerInRange : bool = false
var attackCooldown : bool = false
@export var dmg : int = 20
@export var xpDrop : int = 300
const projectile = preload("res://Scenes/projectile.tscn")

func _ready():
	player = get_node("../../Player")
	$AnimatedSprite2D.play("default")

func takeDmg(amount: int):
	health -= amount
	if health <= 0:
		die()
	print("enemy took ", amount, " damage. Remaining health: ", health)

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
	print("Enemy has been killed")


func _on_attack_cooldown_timeout() -> void:
	attackCooldown = false
	
func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)
