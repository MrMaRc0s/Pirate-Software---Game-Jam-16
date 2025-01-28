extends CharacterBody2D


@export var normalSpeed : int = 120
var SPEED : int = normalSpeed
@export var maxHealth : int = 30
var player
var health : int = maxHealth
var playerInRange : bool = false
@export var dmg : int = 33
@export var xpDrop : int = 200
var attacking : bool = false

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
	if Global.PlayerAlive:
		$AnimatedSprite2D.flip_h = (player.position.x < position.x)
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	playerInRange = true
	if body.has_method("player") and attacking==false:
		$AttackRange/CollisionShape2D.visible = true
		attacking = true
		SPEED = 0
		$AnimatedSprite2D.play("Attack")
		$Boom.start(1)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		playerInRange = false

func die():
	player.giveXp(xpDrop)
	queue_free()
	print("Enemy has been killed")
	
func updateHealthbar():
	var healthbar = $Healthbar
	healthbar.max_value = maxHealth
	healthbar.value = health
	healthbar.visible = (health < maxHealth)


func _on_boom_timeout() -> void:
	if playerInRange:
		player.take_damage(dmg)
	queue_free()
