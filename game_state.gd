extends Node

var banane_count = 0
var coco_count = 0
var can_fire_banane = false
var can_fire_coco = false
var fade_scene = preload("res://fade.tscn")
var fade

var player_scene = preload("res://Player/evo1.tscn")
var player: Node = null

signal player_updated(new_player)

func _ready():
	print("🔁 GameState prêt")

	# Instancier le joueur une seule fois
	player = player_scene.instantiate()
	set_player(player)

	# Charger le premier niveau
	load_level("res://lvl1/lvl1.tscn")
	
	# fondu changement de niveau 
	fade = fade_scene.instantiate()
	add_child(fade)


func set_player(p: Node) -> void:
	player = p
	print("✅ Joueur enregistré dans GameState :", player)
	emit_signal("player_updated", p)

func load_level(scene_path: String) -> void:
	print("🚪 Chargement du niveau :", scene_path)

	# 🕶️ FADE OUT
	if fade:
		await fade.fade_out()

	# Retirer le joueur si déjà en scène
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Supprimer tous les enfants sauf le fade et le joueur
	for child in get_children():
		if child != player and child != fade:
			remove_child(child)
			child.queue_free()

	await get_tree().process_frame

	# Charger la nouvelle scène
	var level = load(scene_path).instantiate()
	add_child(level)
	await get_tree().process_frame

	# Ajouter le joueur dans le nouveau niveau
	level.add_child(player)

	# ✅ Réinitialise le joueur (déverrouiller anim / physique)
	if "reset_state" in player:
		player.reset_state()

	# Positionner le joueur
	var spawn = level.find_child("SpawnPoint", true, false)
	if spawn:
		player.global_position = spawn.global_position
		print("🎯 Joueur placé à :", spawn.global_position)
	else:
		player.global_position = Vector2.ZERO
		print("⚠️ Pas de SpawnPoint trouvé")

	# Activer la caméra si elle existe
	if player.has_node("Camera2D"):
		player.get_node("Camera2D").make_current()
		print("📸 Caméra activée")

	# 🕶️ FADE IN
	if fade:
		await fade.fade_in()

	print_tree_pretty()
