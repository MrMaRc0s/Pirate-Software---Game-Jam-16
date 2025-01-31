extends CharacterBody2D


@export var normalSpeed : int = 0
var SPEED : int = normalSpeed
@export var maxHealth : int = 300
var player
var health : int = maxHealth
var playerInRange : bool = false
var spawnCooldown : bool = false
var attackCooldown : bool = false
@export var dmg : int = 20
@export var xpDrop : int = 300
const projectile = preload("res://Scenes/laser.tscn")
const antibodies = preload("res://Enemies/antibodies.tscn")

func _ready():
	self.scale = Vector2(2, 2)
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
	spawnAntibodies()
	if Global.PlayerAlive:
		$AnimatedSprite2D.flip_h = (player.position.x < position.x)
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()
		
func attackPlayer():
	if not attackCooldown:
		fire1()
		$AttackCooldown2.start(0.6)
		$AttackCooldown3.start(1.2)
		attackCooldown = true
		$AttackCooldown.start(7)

func spawnAntibodies():
	if not spawnCooldown:
		spawnCooldown = true
		$AnimatedSprite2D.play("arise")
		$SpawnTimer.start(10)
		

func fire1():
	var bullet1 = projectile.instantiate()
	bullet1.pos = global_position + Vector2(-3, 2)
	bullet1.direction = (player.position - Vector2(40, 40) - position).angle()
	bullet1.rotation = bullet1.direction
	get_parent().add_child(bullet1)

	var bullet2 = projectile.instantiate()
	bullet2.pos = global_position + Vector2(4, 2)
	bullet2.direction = (player.position - Vector2(40, 35) - position).angle()
	bullet2.rotation = bullet2.direction
	get_parent().add_child(bullet2)
	
func fire2():
	var bullet1 = projectile.instantiate()
	bullet1.pos = global_position + Vector2(5, -12)
	bullet1.direction = (player.position - Vector2(40, 40) - position).angle()
	bullet1.rotation = bullet1.direction
	get_parent().add_child(bullet1)

	var bullet2 = projectile.instantiate()
	bullet2.pos = global_position + Vector2(-2, -12)
	bullet2.direction = (player.position - Vector2(40, 35) - position).angle()
	bullet2.rotation = bullet2.direction
	get_parent().add_child(bullet2)
	
func fire3():
	var bullet1 = projectile.instantiate()
	bullet1.pos = global_position + Vector2(-1, -21)
	bullet1.direction = (player.position - Vector2(40, 40) - position).angle() 
	bullet1.rotation = bullet1.direction
	get_parent().add_child(bullet1) 

	var bullet2 = projectile.instantiate()
	bullet2.pos = global_position + Vector2(5, -21)
	bullet2.direction = (player.position - Vector2(40, 35) - position).angle() 
	bullet2.rotation = bullet2.direction
	get_parent().add_child(bullet2) 


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



func _on_attack_cooldown_2_timeout() -> void:
	fire2()
	$AttackCooldown2.stop()


func _on_attack_cooldown_3_timeout() -> void:
	fire3()
	$AttackCooldown3.stop()


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "arise" and $AnimatedSprite2D.frame == 6:
		var enemyy = antibodies.instantiate()
		get_parent().add_child(enemyy)
	if $AnimatedSprite2D.animation == "arise" and $AnimatedSprite2D.frame == 9:
		$AnimatedSprite2D.play("default")


func _on_spawn_timer_timeout() -> void:
	spawnCooldown = false
