extends Node2D

var enemies: Array = []
var move_timer: float = 0.0
var enemy_speed: float = 0.3

func spawn_enemies(count: int, occupied_positions: Array):
	enemies.clear()
	var spawned = 0
	while spawned < count:
		var pos = Vector2i(
			randi() % Constants.GRID_WIDTH,
			randi() % Constants.GRID_HEIGHT
		)
		if not occupied_positions.has(pos) and not enemies.has(pos):
			enemies.append(pos)
			spawned += 1
	queue_redraw()

func _process(delta):
	move_timer += delta
	if move_timer >= enemy_speed:
		move_timer = 0.0
		move_enemies()

func move_enemies():
	for i in range(enemies.size()):
		# Déplacement aléatoire simple (patrouille basique)
		var dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
		var move = dirs[randi() % dirs.size()]
		var new_pos = enemies[i] + move
		new_pos.x = wrapi(new_pos.x, 0, Constants.GRID_WIDTH)
		new_pos.y = wrapi(new_pos.y, 0, Constants.GRID_HEIGHT)
		enemies[i] = new_pos
	queue_redraw()

const ShatterEffect = preload("res://scenes/shatter_effect.tscn")

func remove_enemy_at(pos: Vector2i) -> bool:
	var index = enemies.find(pos)
	if index != -1:
		spawn_shatter_effect(pos)
		enemies.remove_at(index)
		queue_redraw()
		return true
	return false

func spawn_shatter_effect(grid_pos: Vector2i):
	var effect = ShatterEffect.instantiate()
	var pixel_pos = grid_pos * Constants.GRID_SIZE + Vector2i(Constants.GRID_SIZE / 2, Constants.GRID_SIZE / 2)
	effect.position = pixel_pos
	get_parent().add_child(effect)

func _draw():
	for pos in enemies:
		var draw_pos = pos * Constants.GRID_SIZE
		draw_enemy_body(draw_pos)
		draw_enemy_eyes(draw_pos)

func draw_enemy_body(draw_pos: Vector2):
	var center = draw_pos + Vector2(Constants.GRID_SIZE / 2.0, Constants.GRID_SIZE / 2.0)
	var radius = Constants.GRID_SIZE / 2.0 - 2
	var spike_count = 8
	var points = PackedVector2Array()

	for i in range(spike_count * 2):
		var angle = (TAU / (spike_count * 2)) * i
		var r = radius if i % 2 == 0 else radius * 0.65
		points.append(center + Vector2(cos(angle), sin(angle)) * r)

	draw_polygon(points, PackedColorArray([Color(0.75, 0.1, 0.55)]))

	for i in range(points.size()):
		var next_point = points[(i + 1) % points.size()]
		draw_line(points[i], next_point, Color(0.4, 0.05, 0.3), 1.5)

func draw_enemy_eyes(draw_pos: Vector2):
	var eye_radius = 3.0
	var offset = Constants.GRID_SIZE / 4.0

	var eye1_pos = Vector2(draw_pos.x + offset, draw_pos.y + offset)
	var eye2_pos = Vector2(draw_pos.x + Constants.GRID_SIZE - offset, draw_pos.y + offset)

	draw_circle(eye1_pos, eye_radius, Color.WHITE)
	draw_circle(eye2_pos, eye_radius, Color.WHITE)
	draw_circle(eye1_pos, eye_radius * 0.5, Color.BLACK)
	draw_circle(eye2_pos, eye_radius * 0.5, Color.BLACK)

	var mouth_y = draw_pos.y + Constants.GRID_SIZE - offset
	draw_line(
		Vector2(draw_pos.x + offset, mouth_y),
		Vector2(draw_pos.x + Constants.GRID_SIZE - offset, mouth_y),
		Color.BLACK, 2.0
	)

func set_speed(new_speed: float):
	enemy_speed = new_speed
