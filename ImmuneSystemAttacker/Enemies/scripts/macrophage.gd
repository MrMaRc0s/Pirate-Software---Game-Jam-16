extends CharacterBody2D


@export var normalSpeed : int = 40
var SPEED : int = normalSpeed
@export var maxHealth : int = 50
var player
var health : int = maxHealth
var playerInRange : bool = false
var attackCooldown : bool = false
@export var dmg : int = 10
@export var xpDrop : int = 200

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
		
func attackPlayer():
	if not attackCooldown and playerInRange:
		player.take_damage(dmg)
		attackCooldown = true
		$AttackCooldown.start()
	

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
