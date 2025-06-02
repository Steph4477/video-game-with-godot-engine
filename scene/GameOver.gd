extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$sound/dijee.play()
	#$"VBoxContainer/démarrer".grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	get_tree().change_scene("res://monkey1/lvl1.tscn")
	pass # Replace with function body.


func _on_TextureButton2_pressed():
	pass # Replace with function body.


func _on_menu_pressed():
	get_tree().change_scene("res://monkey1/lvl0tscn.tscn")
	pass # Replace with function body.
