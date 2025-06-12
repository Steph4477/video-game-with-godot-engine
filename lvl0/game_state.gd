extends Node

# Variables persistantes entre les scènes
var banane_count = 0
var coco_count = 0
var can_fire_banane = false
var can_fire_coco = false

signal player_updated(new_player)
var player: Node = null

func set_player(p: Node) -> void:
	emit_signal("player_updated", player)

func _ready():
	print("Mon chemin est : ", get_path())  # utile pour debugger
