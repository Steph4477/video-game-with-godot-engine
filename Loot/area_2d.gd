extends Area2D

@export var coco_value: int = 1
@export var activate_shooting: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("collect_coco"):
		body.collect_coco(3, true)  # +3 coco et active le tir
		queue_free()
