extends CharacterBody2D

@export var speed = 300.0

func _physics_process(delta):
	var direction = 0
	
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1
	
	velocity.x = direction * speed
	
	move_and_slide()
	
	# Keep player within screen bounds
	var screen_size = get_viewport().size
	position.x = clamp(position.x, 50, screen_size.x - 50)
