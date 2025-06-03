extends Node2D

@export var damage: int = 2  # Utilisation de @export en Godot 4

# Fonction qui est appelée lorsque le corps entre dans l'Area2D
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):  # Vérifie si le corps appartient au groupe "Player"
		body.OnHit(damage)  # Applique les dégâts en appelant OnHit sur le corps

# Fonction appelée lors de l'initialisation de la scène
func _ready() -> void:
	pass  # Aucune action nécessaire lors de l'initialisation, tu peux l'enlever ou y ajouter des actions
