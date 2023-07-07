extends CharacterBody2D

@export var speed = 40
var player_chase = false
var player = null
var health = 100

var player_in_attack_zone = false

var can_take_damage = true


func _physics_process(_delta):
	deal_with_damage()
	if player_chase:
		position += (player.position - position) / speed

		if player.position.x < position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	# Whatever enters the detection area is passed through body
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false


func _on_enemy_hitbox_body_entered(body):
	# pass # Replace with function body.
	print(body.name)
	if body.name == "Player":
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	# pass  # Replace with function body.
	if body.name == "Player":
		player_in_attack_zone = false


func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack:
		if can_take_damage:
			health -= 20
			print("Slime health: " + str(health))
			can_take_damage = false
			$take_damage_cooldown.start()
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
