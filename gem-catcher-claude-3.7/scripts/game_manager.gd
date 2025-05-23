extends Node

@export var gem_scene: PackedScene
@export var spawn_interval = 1.0
@export var speed_increase = 10

var score = 0
var game_over = false
var screen_size
var timer = 0

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	$ScoreLabel.text = "Score: 0"
	$GameOverPanel.hide()

func _process(delta):
	if game_over:
		return
		
	timer += delta
	if timer >= spawn_interval:
		spawn_gem()
		timer = 0
		
func spawn_gem():
	var gem = gem_scene.instantiate()
	add_child(gem)
	
	# Random x position
	var gem_width = 40  # Approximate width of the gem
	gem.position = Vector2(randf_range(gem_width, screen_size.x - gem_width), -50)
	
	# Connect signals
	gem.connect("collected", _on_gem_collected)
	gem.connect("missed", _on_gem_missed)
	
	# Increase difficulty as score increases
	gem.fall_speed += score * speed_increase

func _on_gem_collected():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)

func _on_gem_missed():
	game_over = true
	$GameOverPanel.show()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
