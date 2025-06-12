extends Node

var banane_count = 0
var coco_count = 0
var can_fire_banane = false
var can_fire_coco = false
var player: Node = null

signal player_updated(new_player)

func set_player(p: Node) -> void:
	player = p
	print("✅ Joueur enregistré dans GameState :", player)
	emit_signal("player_updated", p)
	print("✅ Joueur mis a jour dans GameState :", player)

func _ready():
	print("🔁 Chargement du game state")
	
	var lvl = preload("res://lvl1/lvl1.tscn").instantiate()
	add_child(lvl)

	
	print("🧩 Arbre actuel dans GameState :")
	for child in get_children():
		print(" -", child.name)

	await lvl.ready
	await get_tree().process_frame  # ← attendre une frame supplémentaire

	print("📦 lvl1 contient ces enfants :")
	for child in lvl.get_children():
		print(" -", child.name)

	var player = lvl.find_child("Player", true, false)
	if player:
		print("✅ Player trouvé :", player)
		player.player_ready.connect(_on_player_ready)
	else:
		print("❌ Player introuvable après instanciation")

func _on_player_ready(player):
	print("🎯 Signal reçu depuis Player :", player.name)
	player.set_game_state(self)
