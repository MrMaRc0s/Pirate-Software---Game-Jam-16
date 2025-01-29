extends CharacterBody2D

# Variables
var enemiesInRange: Array[Node2D] = []
@export var speed : int = 100
@export var maxHealth : int = 100000
var face : bool = false
var attackCooldown : bool = true
var health : int = maxHealth
@export var dmg : int = 10
var currentTargetIndex: int = 0  # Keep track of which enemy to attack
@export var nextLvl: int = 500
var level : int = 1
var xp : int = 0
@onready var damageTimer = $DamageTimer
var walking : bool = false

func _ready():
	play_anim("hahaha")

func _physics_process(delta):
	updateHealthbar()
	updateXpbar()
	player_movement(delta)
	move_and_slide() 
	AttackEnemy()
	if velocity != Vector2(0,0):
		startWalking()
	else:
		play_anim("hahaha")
		walking = false
		
func startWalking():
	if walking == false:
		play_anim("Walking")
		#$StartWalking.start(1)

func player_movement(_delta):
	# Reset movement velocity
	velocity = Vector2.ZERO

	# Check for movement inputs and set velocity accordingly
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		face = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		face = false
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
	else:
		turn_red()

func turn_red():
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	damageTimer.start(0.3)
	
func _on_damage_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1) 

func _on_attack_cooldown_timeout() -> void:
	attackCooldown = true

func die():
	Global.PlayerAlive = false
	get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")
	queue_free()

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
		xp -= nextLvl
		nextLvl+=200
		print("Leveled up!!! ", level)

func _on_health_regen_timeout() -> void:
	if health < maxHealth:
		health += 2
		if health > maxHealth:
			health = maxHealth
			print("HealthRegen +2 hp new player health ", health)
	if health <= 0:
		health = 0
		$HealthRegen.stop()
func player():
	pass


func _on_start_walking_timeout() -> void:
	$StartWalking.stop()
	walking = true
	play_anim("Walking")
