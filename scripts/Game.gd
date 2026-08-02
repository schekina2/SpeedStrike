extends Node2D

@onready var snake = $Snake
@onready var food = $Food
@onready var enemies = $Enemies
@onready var score_label = $HUD/ScoreLabel
@onready var dash_label = $HUD/DashLabel
@onready var level_label = $HUD/LevelLabel
@onready var sfx_player = $SFXPlayer
@onready var mute_button = $HUD/MuteButton

var score: int = 0
var current_level: int = 1

func _ready():
	apply_level_config()
	food.respawn(snake.body)
	update_hud()
	snake.dash_started.connect(_on_dash_started)
	mute_button.pressed.connect(_on_mute_pressed)
	update_mute_button()

func _on_mute_pressed():
	SoundManager.toggle_mute()
	update_mute_button()

func update_mute_button():
	mute_button.text = "🔇" if SoundManager.is_muted else "🔊"

func _on_dash_started():
	SoundManager.play_dash_sound(sfx_player)

func _process(_delta):
	check_food_collision()
	check_self_collision()
	check_enemy_collision()
	check_level_up()
	update_hud()

func apply_level_config():
	var config = Constants.LEVEL_CONFIG[current_level]
	enemies.set_speed(config["enemy_speed"])
	enemies.spawn_enemies(config["enemy_count"], snake.body)

func check_level_up():
	if current_level == 1 and score >= Constants.LEVEL_2_SCORE:
		current_level = 2
		apply_level_config()
	elif current_level == 2 and score >= Constants.LEVEL_3_SCORE:
		current_level = 3
		apply_level_config()

func check_food_collision():
	if snake.get_head_position() == food.grid_position:
		snake.grow()
		score += 1
		food.respawn(snake.body)
		SoundManager.play_eat_sound(sfx_player)

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
			SoundManager.play_kill_sound(sfx_player)
	else:
		if enemies.enemies.has(head):
			game_over()

func update_hud():
	score_label.text = "Score: %d" % score
	level_label.text = "Niveau %d" % current_level
	if snake.is_dashing:
		dash_label.text = "DASH ACTIF !"
	elif snake.dash_cooldown_timer > 0:
		dash_label.text = "Dash: %.1fs" % snake.dash_cooldown_timer
	else:
		dash_label.text = "Dash: PRÊT"

func game_over():
	Constants.last_score = score
	SoundManager.play_game_over_sound(sfx_player)
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
