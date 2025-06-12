extends Area2D

var abdo_player_scene := preload("res://Player/evo2.tscn")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var abdo_version = abdo_player_scene.instantiate()
		abdo_version.position = body.position
		var parent = body.get_parent()
		parent.add_child(abdo_version)
		
		# 🧠 Signaler le nouveau joueur au GameState
		var game_state = get_node_or_null("/root/GameManagement/SceneContainer/GameState")
		if game_state:
			game_state.set_player(abdo_version)
		
		body.queue_free()  # supprime l'ancien joueur
		queue_free()       # supprime le loot
