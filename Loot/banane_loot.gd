extends Node2D

@export var banane_value: int = 1
@export var activate_shooting: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("collect_banane"):
		body.collect_banane(5, true)  # +5 bananes et active le tir
		queue_free()
