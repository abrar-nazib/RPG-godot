extends CharacterBody2D

@export var speed = 100
var current_dir = "none"


func _physics_process(delta):
	player_movement(delta)


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
			anim.play("side_idle")
	elif dir == "right":
		anim.flip_h = false
		if movement:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	elif dir == "up":
		if movement:
			anim.play("back_walk")
		else:
			anim.play("back_idle")
	elif dir == "down":
		if movement:
			anim.play("front_walk")
		else:
			anim.play("front_idle")
	else:
		anim.play("front_idle")
