extends Node2D

# Bananier.gd
@onready var area = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("set_can_climb"):
		body.set_can_climb(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("set_can_climb"):
		body.set_can_climb(false)
