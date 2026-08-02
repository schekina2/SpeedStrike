extends Node2D

func _ready():
	create_fragments()

func create_fragments(color: Color = Color(0.8, 0.1, 0.6)):
	var fragment_count = 6
	for i in range(fragment_count):
		var fragment = ColorRect.new()
		fragment.size = Vector2(6, 6)
		fragment.color = color
		fragment.position = Vector2(-3, -3)
		add_child(fragment)

		var angle = (TAU / fragment_count) * i + randf_range(-0.3, 0.3)
		var speed = randf_range(60, 120)
		var target_offset = Vector2(cos(angle), sin(angle)) * speed

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(fragment, "position", fragment.position + target_offset, 0.4).set_ease(Tween.EASE_OUT)
		tween.tween_property(fragment, "modulate:a", 0.0, 0.4)
		tween.tween_property(fragment, "rotation", randf_range(-PI, PI), 0.4)

	await get_tree().create_timer(0.45).timeout
	queue_free()
