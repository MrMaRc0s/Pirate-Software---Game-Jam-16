extends CharacterBody2D

# Variables
var enemiesInRange: Array[Node2D] = []
@export var speed : int = 100
@export var maxHealth : int = 160
var face : bool = false
var attackCooldown : bool = true
var attaking : bool = false
var health : int = maxHealth
@export var dmg : int = 15
var currentTargetIndex: int = 0  # Keep track of which enemy to attack
@export var nextLvl: int = 500
var level : int = 1
var xp : int = 0
@onready var damageTimer = $DamageTimer
var walking : bool = false
var closest_enemy = null
const knife = preload("res://Scenes/Knife.tscn")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sfx_knife_1: AudioStreamPlayer2D = $sfx_knife_1
@onready var sfx_knife_2: AudioStreamPlayer2D = $sfx_knife_2


func _ready():
	play_anim("hahaha")
	$DisplayXpGain.text = ""

func _physics_process(delta):
	updateHealthbar()
	updateXpbar()
	player_movement(delta)
	move_and_slide() 
	AttackEnemy()
	if velocity != Vector2(0,0) && !attaking:
		play_anim("Walking")
	elif velocity == Vector2(0,0) && !attaking:
		play_anim("hahaha")
		walking = false
	elif attaking && velocity != Vector2(0,0):
		Global.Dmg = dmg
		play_anim("attackOnMove")
	elif attaking && velocity == Vector2(0,0):
		Global.Dmg = dmg + (dmg / 2)
		play_anim("attackOnIdle")
	

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
	$AnimatedSprite2D.flip_h = face  # Flip sprite based on facing direction
	$AnimatedSprite2D.play(anim)

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("takeDmg") and not enemiesInRange.has(body):
		enemiesInRange.append(body)

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("takeDmg"):
		enemiesInRange.erase(body)
		if len(enemiesInRange) <=0:
			attaking = false
		
func AttackEnemy():
	if not enemiesInRange.is_empty():
		attaking = true
		attackCooldown = false
		$AttackCooldown.start()
		 # Find the closest enemy
		var closest_distance = INF
		for enemy in enemiesInRange:
			if is_instance_valid(enemy):
				var distance = position.distance_to(enemy.position)
				if distance < closest_distance:
					closest_distance = distance
					closest_enemy = enemy
		
		if closest_enemy:
			#closest_enemy.takeDmg(dmg)
			if closest_enemy.health <= 0:
				enemiesInRange.erase(closest_enemy)

func take_damage(amount: int):
	health -= amount
	print("Player took ", amount, " damage. Remaining health: ", health)
	if health <= 0:
		die()
	else:
		turn_red()
		audio_stream_player_2d.play()

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
	$Timer.start(0.4)
	$DisplayXpGain.text = "+"+str(amount)+"XP"
	xp+=amount
	print("xp= ",xp)
	if xp >=nextLvl:
		maxHealth+=10
		dmg+=1
		level+=1
		xp -= nextLvl
		nextLvl+=350
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

func fire():
	if closest_enemy and is_instance_valid(closest_enemy):  # Ensure the enemy exists
		var knife_instance = knife.instantiate() # Instantiate the knife
		var direction = (closest_enemy.global_position - global_position).normalized()  # Calculate direction to enemy
		knife_instance.pos = global_position + Vector2(-3, 2)  # Set knife's initial position
		knife_instance.rotation = direction.angle()  # Set knife's rotation to face the enemy
		knife_instance.direction = direction
		knife_instance.scale = Vector2(0.7, 0.7)
		get_parent().add_child(knife_instance)  # Add the instantiated knife to the scene
	

func _on_timer_timeout() -> void:
	$DisplayXpGain.text = ""
	

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attackOnMove" and $AnimatedSprite2D.frame == 6:
		Global.ReverseKnife = false
		fire()
		sfx_knife_1.play()
	if $AnimatedSprite2D.animation == "attackOnIdle" and $AnimatedSprite2D.frame == 4:
		Global.ReverseKnife = true
		fire() 
		sfx_knife_2.play()
