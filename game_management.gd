#extends Node
#
## Variables persistantes entre les scènes
#var banane_count = 0
#var coco_count = 0
#var can_fire_banane = false
#var can_fire_coco = false
#
#signal player_updated(new_player)
#var player: Node = null
#
#func set_player(p: Node) -> void:
	#emit_signal("player_updated", player)
#
#func _ready():
	#print("Mon chemin est : ", get_path())  # utile pour debugger
extends Node

@onready var container := $SceneContainer

func _ready():
	print("🔁 Chargement du menu au démarrage")
	load_main_menu()

func load_main_menu():
	_clear_container()
	var menu = preload("res://lvl0/lvl0.tscn").instantiate()
	container.add_child(menu)

func load_game():
	_clear_container()
	var game_state = preload("res://game_state.tscn").instantiate()
	container.add_child(game_state)

func _clear_container():
	for child in container.get_children():
		print("🧹 Suppression de :", child.name)
		child.queue_free()
