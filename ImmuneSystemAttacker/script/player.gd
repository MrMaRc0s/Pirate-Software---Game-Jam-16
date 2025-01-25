extends CharacterBody2D

var targetEnemy: Node2D = null

const speed = 300.0
const maxHealth = 100
var face = false
var enemyInRange = false
var attackCooldown = true
var health = maxHealth
var dmg = 10

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	updateHealthbar()
	player_movement(delta)
	AttackEnemy()

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
	play_anim("default")
	move_and_slide()
	


func play_anim(anim: StringName):
	var animation = $AnimatedSprite2D
	animation.flip_h = face
	animation.play(anim)

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("takeDmg"):
		enemyInRange = true
		targetEnemy = body
	
func player():
	pass

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("takeDmg"):
		enemyInRange = false
		targetEnemy = null
		
func AttackEnemy():
	if enemyInRange and attackCooldown:
		attackCooldown = false
		$AttackCooldown.start()
		targetEnemy.takeDmg(dmg)
		play_anim("attackAnim")

func take_damage(amount: int):
	health -= amount
	print("Player took ", amount, " damage. Remaining health: ", health)
	if health <= 0:
		die()


func _on_attack_cooldown_timeout() -> void:
	attackCooldown = true
	
func die():
	Global.PlayerAlive = false
	queue_free()
	print("Player has been killed")


func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.value = health
	healthbar.visible = (health < maxHealth)

func _on_health_regen_timeout() -> void:
	if health < maxHealth:
		health +=5
		if health > maxHealth:
			health = maxHealth
	if health <=0:
		health = 0
		$HealthRegen.stop()
