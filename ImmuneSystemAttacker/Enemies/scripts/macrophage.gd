extends CharacterBody2D


var normalSpeed : int = 20
var SPEED : int = normalSpeed
const maxHealth : int = 50
var player
var health : int = maxHealth
var playerInRange : bool = false
var attackCooldown : bool = false
var dmg : int = 1

func _ready():
	player = get_node("../Player")
	$AnimatedSprite2D.play("default")

func takeDmg(amount: int):
	health -= amount
	if health <= 0:
		die()
	print("enemy took ", amount, " damage. Remaining health: ", health)

func enemy():
	pass


func _physics_process(delta):
	$AnimatedSprite2D.flip_h = (player.position.x < position.x)
	updateHealthbar()
	attackPlayer()
	if Global.PlayerAlive:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	if health <=0:
		self.queue_free()


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
	queue_free()
	print("Enemy has been killed")


func _on_attack_cooldown_timeout() -> void:
	attackCooldown = false
	
func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)
