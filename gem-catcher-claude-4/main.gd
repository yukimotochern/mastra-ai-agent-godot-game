extends Node2D

@onready var player = $Player
@onready var gem_spawn_timer = $GemSpawnTimer
@onready var ui = $UI
@onready var game_over_label = $UI/GameOverLabel

var gem_scene = preload("res://gem.tscn")
var score = 0
var game_over = false

func _ready():
	gem_spawn_timer.timeout.connect(_on_gem_spawn_timer_timeout)
	update_score()

func _on_gem_spawn_timer_timeout():
	if game_over:
		return
	spawn_gem()

func spawn_gem():
	var gem = gem_scene.instantiate()
	add_child(gem)
	gem.position.x = randf() * (get_viewport().size.x - 40) + 20
	gem.position.y = -20
	gem.gem_caught.connect(_on_gem_caught)
	gem.gem_missed.connect(_on_gem_missed)

func _on_gem_caught():
	score += 10
	update_score()

func _on_gem_missed():
	game_over = true
	gem_spawn_timer.stop()
	game_over_label.visible = true
	game_over_label.text = "GAME OVER\nFinal Score: " + str(score) + "\nPress R to restart"

func update_score():
	ui.get_node("ScoreLabel").text = "Score: " + str(score)

func _input(event):
	if game_over and event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.keycode == KEY_R):
		restart_game()

func restart_game():
	get_tree().reload_current_scene()
