extends CharacterBody2D

@export var speed = 500

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()
	
	# Keep the pad within screen bounds
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
