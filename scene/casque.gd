extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies :
		if body.name == "ralf":
			get_tree().change_scene("res://scene/lootcasque.tscn")
			


func _ready():
	pass
