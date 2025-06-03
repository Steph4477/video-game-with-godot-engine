extends RigidBody2D

@export var speed: int = 1
@export var longueur = Vector2(500, 0)

@onready var tween = $Tween  # Référence au Tween dans la scène

func _ready():
	move()

# Fonction pour déplacer le RigidBody2D avec Tween
func move():
	tween.tween_property(
		self,  # L'objet à animer
		"position",  # La propriété à animer (position)
		global_position,  # Position de départ
		global_position + longueur,  # Position cible
		speed,  # Durée de l'animation
		Tween.TRANS_CIRC,  # Type de transition
		Tween.EASE_IN_OUT  # Type d'interpolation
	)

# Fonction qui est appelée quand le Tween termine son animation
func _on_Tween_tween_all_completed():
	longueur *= -1  # Inverse la direction
	move()  # Lance à nouveau le mouvement
