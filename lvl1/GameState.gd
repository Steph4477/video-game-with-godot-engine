extends Node

# Variables persistantes entre les scènes
var banane_count = 0
var coco_count = 0
var can_fire_banane = false
var can_fire_coco = false

signal player_updated(new_player)
var player: Node = null

func set_player(player: Node) -> void:
	emit_signal("player_updated", player)

func get_player() -> Node:
	return player

func _ready():
	print("Mon chemin est : ", get_path())  # utile pour debugger

	var lvl_scene = preload("res://lvl1/lvl1.tscn")
	var lvl = lvl_scene.instantiate()
	add_child(lvl)

	await lvl.ready  # attendre que lvl1 soit prêt dans l’arbre

	var player = lvl.get_node("player")  # ⚠️ vérifie que "Player" est le bon nom du nœud
	player.set_game_state(self)
