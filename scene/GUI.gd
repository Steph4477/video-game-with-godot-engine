extends CanvasLayer
#onready var health_globe = get_node ("HealthGlobe/GlobeFull/TextureProgress")  
#onready var health_globe_tween = get_node ("HealthGlobe/GlobeFull/TextureProgress/Tween")
#var new_up = get_node("HealthGlobe/GlobeFull/TextureProgress/Tween")
#
#
#
#	health_globe.max_value = get_node("res://scene/ralf.tscn")
#	health_globe.value = ("res://scene/ralf.tscn")
#func _process(delta):
#	UpdateGlobes ()
#
#func UpdateGlobes () :
#	var new_up = get_node("HealthGlobe/GlobeFull/TextureProgress/Tween").current_hp 
##	health_globe_tween.interpolate_property(health_globe, "value", health_globe.value, Tween.TRANS_LINEAR)
##	health_globe_tween.start()
func _input(event):
	if event.is_action_pressed("menu"):
		get_tree().change_scene("res://scene/lvl1.tscn")
		
func change_val(val):
	$Label.text = str(val)

func _ready():
	$Label.text = "0"



