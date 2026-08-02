extends Node2D

var grid_position: Vector2i
var pulse_time: float = 0.0

func _process(delta):
	pulse_time += delta
	queue_redraw()
	
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
	var center = Vector2(pos.x + Constants.GRID_SIZE / 2.0, pos.y + Constants.GRID_SIZE / 2.0)
	var radius = Constants.GRID_SIZE / 2.0 - 3
	var pulse = 1.0 + sin(pulse_time * 4.0) * 0.08

	draw_circle(center + Vector2(0, 2), radius * pulse, Color(0.85, 0.15, 0.15))
	var stem_pos = Vector2(center.x - 1.5, pos.y + 2)
	draw_rect(Rect2(stem_pos.x, stem_pos.y, 3, 6), Color(0.4, 0.25, 0.1))

	var leaf_points = PackedVector2Array([
		Vector2(center.x + 1, pos.y + 4),
		Vector2(center.x + 9, pos.y),
		Vector2(center.x + 7, pos.y + 7)
	])
	draw_polygon(leaf_points, PackedColorArray([Color(0.2, 0.7, 0.2)]))
