extends Node2D

var enemies: Array = []  # liste de Vector2i (positions en grille)
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

func remove_enemy_at(pos: Vector2i) -> bool:
	var index = enemies.find(pos)
	if index != -1:
		enemies.remove_at(index)
		queue_redraw()
		return true
	return false

func _draw():
	for pos in enemies:
		var draw_pos = pos * Constants.GRID_SIZE
		draw_rect(Rect2(draw_pos.x, draw_pos.y, Constants.GRID_SIZE - 2, Constants.GRID_SIZE - 2), Color(0.8, 0.1, 0.6))
