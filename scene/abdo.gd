extends Area2D

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Georges":
			body.queue_free()
			get_tree().change_scene("res://scene/lvl2.tscn")


func _ready():
	pass

