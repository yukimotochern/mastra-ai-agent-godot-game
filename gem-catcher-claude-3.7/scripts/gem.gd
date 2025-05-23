extends Area2D

@export var fall_speed = 200
signal collected
signal missed

func _process(delta):
	position.y += fall_speed * delta
	
	# Check if the gem has fallen off the screen
	if position.y > get_viewport_rect().size.y:
		emit_signal("missed")
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("collected")
		queue_free()
