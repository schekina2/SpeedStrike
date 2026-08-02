extends Node2D

var grid_position: Vector2i

func _ready():
	randomize()
	respawn([])

func respawn(occupied_positions: Array):
	var valid_position = false
	while not valid_position:
		grid_position = Vector2i(
			randi() % Constants.GRID_WIDTH,
			randi() % Constants.GRID_HEIGHT
		)
		valid_position = not occupied_positions.has(grid_position)
	queue_redraw()

func _draw():
	var pos = grid_position * Constants.GRID_SIZE
	draw_rect(Rect2(pos.x, pos.y, Constants.GRID_SIZE - 2, Constants.GRID_SIZE - 2), Color(1, 0.9, 0.2))
