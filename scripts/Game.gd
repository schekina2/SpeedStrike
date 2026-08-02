extends Node2D

@onready var snake = $Snake
@onready var food = $Food
@onready var enemies = $Enemies
@onready var score_label = $HUD/ScoreLabel
@onready var dash_label = $HUD/DashLabel

var score: int = 0
const ENEMY_COUNT = 3

func _ready():
	food.respawn(snake.body)
	enemies.spawn_enemies(ENEMY_COUNT, snake.body)
	update_hud()

func _process(_delta):
	check_food_collision()
	check_self_collision()
	check_enemy_collision()
	update_hud()

func check_food_collision():
	if snake.get_head_position() == food.grid_position:
		snake.grow()
		score += 1
		food.respawn(snake.body)

func check_self_collision():
	var head = snake.get_head_position()
	for i in range(1, snake.body.size()):
		if snake.body[i] == head:
			game_over()
			break

func check_enemy_collision():
	var head = snake.get_head_position()
	if snake.is_dashing:
		if enemies.remove_enemy_at(head):
			score += 3
	else:
		if enemies.enemies.has(head):
			game_over()

func update_hud():
	score_label.text = "Score: %d" % score
	if snake.is_dashing:
		dash_label.text = "DASH ACTIF !"
	elif snake.dash_cooldown_timer > 0:
		dash_label.text = "Dash: %.1fs" % snake.dash_cooldown_timer
	else:
		dash_label.text = "Dash: PRÊT"

func game_over():
	Constants.last_score = score
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
