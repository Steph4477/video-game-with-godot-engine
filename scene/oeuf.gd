extends Sprite2D

@onready var PlayerScript = get_node("/root/Georges")  # Recherche du nœud "Georges" dans la scène
@onready var GUIScript = get_node("/root/GUI")  # Recherche du nœud "GUI" dans la scène

# Fonction appelée lorsqu'un corps entre dans la zone de détection
func _on_Area2D_body_entered(_body: Node) -> void:
	# Augmente les pièces du joueur
	PlayerScript.coins += 1
	
	# Met à jour la valeur affichée dans l'interface utilisateur
	GUIScript.change_val(PlayerScript.coins)
	
	# Interpolation de la position du sprite
	$Tween.tween_property(self, "position", position, Vector2(position.x - 300, position.y - 300), 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	# Interpolation de la taille du sprite
	$Tween.tween_property(self, "scale", Vector2(1, 1), Vector2(2, 2), 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	# Interpolation de la transparence du sprite
	$Tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 0.5)
	
	# Démarrer l'animation de tween
	$Tween.start()

	# Attendre que le tween soit terminé avant de libérer le nœud
	await $Tween.tween_completed  # Il faut utiliser "await" pour attendre la fin de l'animation
	
	queue_free()  # Supprime ce nœud après l'animation
