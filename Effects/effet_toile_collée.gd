extends Node2D

func _ready():
	await get_tree().create_timer(1.0).timeout
	queue_free()
