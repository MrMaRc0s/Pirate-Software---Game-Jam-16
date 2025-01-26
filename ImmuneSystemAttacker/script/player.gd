extends CharacterBody2D

# Variables
var enemiesInRange: Array[Node2D] = []
@export var speed : int = 100
@export var maxHealth : int = 100
var face : bool = false
var attackCooldown : bool = true
var health : int = maxHealth
@export var dmg : int = 10
var currentTargetIndex: int = 0  # Keep track of which enemy to attack
@export var nextLvl: int = 500
var level : int = 1
var xp : int = 0

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	updateHealthbar()
	updateXpbar()
	player_movement(delta)
	move_and_slide() 
	AttackEnemy()

func player_movement(delta):
	# Reset movement velocity
	velocity = Vector2.ZERO

	# Check for movement inputs and set velocity accordingly
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		face = false  # Update facing direction
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		face = true
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed

func play_anim(anim: StringName):
	var animation = $AnimatedSprite2D
	animation.flip_h = face  # Flip sprite based on facing direction
	animation.play(anim)

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("takeDmg") and not enemiesInRange.has(body):
		enemiesInRange.append(body)

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("takeDmg"):
		enemiesInRange.erase(body)
		
func AttackEnemy():
	if not enemiesInRange.is_empty() and attackCooldown:
		attackCooldown = false
		$AttackCooldown.start()
		
		 # Find the closest enemy
		var closest_enemy = null
		var closest_distance = INF
		for enemy in enemiesInRange:
			if is_instance_valid(enemy):
				var distance = position.distance_to(enemy.position)
				if distance < closest_distance:
					closest_distance = distance
					closest_enemy = enemy
		
		if closest_enemy:
			closest_enemy.takeDmg(dmg)
			if closest_enemy.health <= 0:
				enemiesInRange.erase(closest_enemy)

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
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)
	
func updateXpbar():
	var xpbar = $Xpbar
	xpbar.max_value = nextLvl
	xpbar.value = xp

func giveXp(amount: int):
	xp+=amount
	print("xp= ",xp)
	if xp >=nextLvl:
		level+=1
		xp = 0
		nextLvl+=200
		print("Level up! u are now ", level)

func _on_health_regen_timeout() -> void:
	if health < maxHealth:
		health += 5
		if health > maxHealth:
			health = maxHealth
			print("HealthRegen +5 hp new player health ", health)
	if health <= 0:
		health = 0
		$HealthRegen.stop()
func player():
	pass
