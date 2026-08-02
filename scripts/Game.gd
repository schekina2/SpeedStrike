extends Node2D

@onready var snake = $Snake
@onready var food = $Food

var score: int = 0

func _ready():
	food.respawn(snake.body)

func _process(_delta):
	check_food_collision()
	check_self_collision()

func check_food_collision():
	if snake.get_head_position() == food.grid_position:
		snake.grow()
		score += 1
		print("Score: ", score)
		food.respawn(snake.body)

func check_self_collision():
	var head = snake.get_head_position()
	for i in range(1, snake.body.size()):
		if snake.body[i] == head:
			game_over()
			break

func game_over():
	print("Game Over! Score final: ", score)
	get_tree().paused = true
