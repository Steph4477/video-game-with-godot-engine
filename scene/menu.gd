extends Node2D

func _ready ():	
	$sound/dijee.play()
	$"VBoxContainer/démarrer".grab_focus()

func _on_dmarrer_pressed():
	get_tree().change_scene_to_file("res://lvl1/lvl1.tscn")
	
func _on_Options_pressed():
	pass
	
func _on_Quitter_pressed():
	pass
	
