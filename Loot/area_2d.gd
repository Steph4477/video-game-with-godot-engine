extends Node2D

@export var flaque_texture: Texture2D

func _ready() -> void:
	# Référence au corps physique de la bave
	var b2b := $RigidBody2D as RigidBody2D

	# Lance l’animation d’écrasement (spawn aplati)
	b2b.get_node("AnimationPlayer").play("splat_flatten")

	# Attendre la fin de l’animation
	await b2b.get_node("AnimationPlayer").animation_finished

	# Bascule en mode statique pour figer la bave
	b2b.mode = RigidBody2D.MODE_STATIC

	# Change la texture (vers version aplatie brillante)
	b2b.get_node("Sprite2D").texture = flaque_texture
