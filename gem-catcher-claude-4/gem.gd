extends RigidBody2D

signal gem_caught
signal gem_missed

@export var fall_speed = 200.0

func _ready():
	linear_velocity = Vector2(0, fall_speed)
	# Connect to area entered signal for collision detection
	var area = $Area2D
	area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		gem_caught.emit()
		queue_free()

func _physics_process(delta):
	if position.y > get_viewport().size.y + 50:
		gem_missed.emit()
		queue_free()
