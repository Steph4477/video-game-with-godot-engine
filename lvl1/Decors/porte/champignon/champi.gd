extends Area2D

@export var next_scene_path: String

func _on_body_entered(body):
	if body.name == "Player": 
		print ("collision avec : " + body.name)
		#get_tree().change_scene_to_file(next_scene_path)
		var game_state = get_node_or_null("/root/GameManagement/SceneContainer/GameState")
		game_state.load_level(next_scene_path)
