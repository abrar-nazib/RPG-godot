extends CharacterBody2D

@export var speed = 100
var current_dir = "none"

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false


func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()

	if health <= 0:
		player_alive = false  # Add end screen
		health = 0
		print("Player died")
		self.queue_free()  # free the memory


func player_movement(_delta):
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(true)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(true)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(true)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(true)
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(false)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "left":
		anim.flip_h = true
		if movement:
			anim.play("side_walk")
		else:
			if not attack_ip:
				anim.play("side_idle")
			else:
				anim.play("side_attack")
	elif dir == "right":
		anim.flip_h = false
		if movement:
			anim.play("side_walk")
		else:
			if not attack_ip:
				anim.play("side_idle")
			else:
				anim.play("side_attack")
	elif dir == "up":
		if movement:
			anim.play("back_walk")
		else:
			if not attack_ip:
				anim.play("back_idle")
			else:
				anim.play("back_attack")
	elif dir == "down":
		if movement:
			anim.play("front_walk")
		else:
			if not attack_ip:
				anim.play("front_idle")
			else:
				anim.play("front_attack")
	else:
		anim.play("front_idle")


func _on_player_hitbox_body_entered(body):
	# Check whether enemy has entered
	if body.name == "enemy":
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	# Check whether enemy has exited
	if body.name == "enemy":
		enemy_in_attack_range = false


func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player health: " + str(health))


func attack():
	if Input.is_action_pressed("attack"):
		attack_ip = true
		Global.player_current_attack = true
		$deal_attack_timer.start()


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	attack_ip = false
	Global.player_current_attack = false
	print(attack_ip)
