extends Area2D

@export var speed := 30.0
@export var lifetime := 2.0
@export var scale_growth := 1.5

var direction := 1
var time_passed := 0.0
var damage = 10
func start(pos: Vector2, dir: int) -> void:
	position = pos
	direction = dir
	scale = Vector2(0.2, 0.2)  # Départ petit

func _process(delta: float) -> void:
	time_passed += delta

	# 1. Remonte légèrement
	if time_passed < 0.3:
		position.y -= speed * delta
	else:
		position.y += speed * delta * 0.4  # redescente lente

	# 2. Grandit progressivement
	if scale.x < scale_growth:
		scale += Vector2(0.4, 0.4) * delta

	# 3. Disparait après X secondes
	if time_passed > lifetime:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("on_hit"):
			body.on_hit(damage)

	
