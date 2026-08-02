extends Node2D

signal dash_started
signal dash_ended
signal enemy_killed(enemy)

var body: Array = []  # liste des positions (Vector2i) en coordonnées de grille
var direction: Vector2i = Vector2i(1, 0)
var next_direction: Vector2i = Vector2i(1, 0)

var move_timer: float = 0.0
var current_speed: float = Constants.BASE_SPEED

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

func _ready():
	# Position de départ : 3 segments au centre de la grille
	var start_x = int(Constants.GRID_WIDTH / 2.0)
	var start_y = int(Constants.GRID_HEIGHT / 2.0)
	body = [
		Vector2i(start_x, start_y),
		Vector2i(start_x - 1, start_y),
		Vector2i(start_x - 2, start_y)
	]
	queue_redraw()

func _process(delta):
	handle_input()
	update_dash(delta)
	move_timer += delta
	if move_timer >= current_speed:
		move_timer = 0.0
		move_snake()
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func handle_input():
	if Input.is_action_just_pressed("move_up") and direction != Vector2i(0, 1):
		next_direction = Vector2i(0, -1)
	elif Input.is_action_just_pressed("move_down") and direction != Vector2i(0, -1):
		next_direction = Vector2i(0, 1)
	elif Input.is_action_just_pressed("move_left") and direction != Vector2i(1, 0):
		next_direction = Vector2i(-1, 0)
	elif Input.is_action_just_pressed("move_right") and direction != Vector2i(-1, 0):
		next_direction = Vector2i(1, 0)

	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
		start_dash()

func start_dash():
	is_dashing = true
	dash_timer = Constants.DASH_DURATION
	current_speed = Constants.DASH_SPEED
	dash_cooldown_timer = Constants.DASH_COOLDOWN
	dash_started.emit()

func update_dash(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			current_speed = Constants.BASE_SPEED
			dash_ended.emit()

func move_snake():
	direction = next_direction
	var new_head = body[0] + direction

	new_head.x = wrapi(new_head.x, 0, Constants.GRID_WIDTH)
	new_head.y = wrapi(new_head.y, 0, Constants.GRID_HEIGHT)

	body.insert(0, new_head)
	body.pop_back()
	queue_redraw()

func grow():
	body.append(body[body.size() - 1])

func get_head_position() -> Vector2i:
	return body[0]

func _draw():
	for i in range(body.size()):
		var pos = body[i] * Constants.GRID_SIZE
		var color = Color(1, 0.4, 0.1) if is_dashing else Color(0.2, 0.8, 0.3)
		if i == 0:
			color = Color(1, 0.6, 0.1) if is_dashing else Color(0.1, 0.9, 0.4)
		draw_rect(Rect2(pos.x, pos.y, Constants.GRID_SIZE - 2, Constants.GRID_SIZE - 2), color)

	# Yeux sur la tête
	draw_eyes()

func draw_eyes():
	var head_pos = body[0] * Constants.GRID_SIZE
	var eye_radius = 3.0
	var offset = Constants.GRID_SIZE / 4.0

	var eye1_pos: Vector2
	var eye2_pos: Vector2

	if direction == Vector2i(1, 0):
		eye1_pos = Vector2(head_pos.x + Constants.GRID_SIZE - offset, head_pos.y + offset)
		eye2_pos = Vector2(head_pos.x + Constants.GRID_SIZE - offset, head_pos.y + Constants.GRID_SIZE - offset)
	elif direction == Vector2i(-1, 0):
		eye1_pos = Vector2(head_pos.x + offset, head_pos.y + offset)
		eye2_pos = Vector2(head_pos.x + offset, head_pos.y + Constants.GRID_SIZE - offset)
	elif direction == Vector2i(0, -1):
		eye1_pos = Vector2(head_pos.x + offset, head_pos.y + offset)
		eye2_pos = Vector2(head_pos.x + Constants.GRID_SIZE - offset, head_pos.y + offset)
	else:
		eye1_pos = Vector2(head_pos.x + offset, head_pos.y + Constants.GRID_SIZE - offset)
		eye2_pos = Vector2(head_pos.x + Constants.GRID_SIZE - offset, head_pos.y + Constants.GRID_SIZE - offset)

	draw_circle(eye1_pos, eye_radius, Color.BLACK)
	draw_circle(eye2_pos, eye_radius, Color.BLACK)
