extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/Démarrer".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dmarrer_pressed():
	get_tree().change_scene("res://monkey1/lvl1.tscn")
	pass
	


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quitter_pressed():
	get_tree().quit
	pass # Replace with function body.



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


