extends Label

@export var float_distance := 40
@export var duration := 0.5

func show_damage(amount: int) -> void:
	print("show_damage appelé avec :", amount)
	text = "-" + str(amount)
	modulate = Color.YELLOW
	position.y = 0

	var tween = create_tween()
	tween.tween_property(self, "position:y", -float_distance, duration)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	await tween.finished
	queue_free()
