extends Area2D
func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies :
		if body.name == "Georges":
			get_tree().change_scene("res://scene/lvl3.tscn")
			


func _ready():
	pass
