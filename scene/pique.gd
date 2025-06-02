extends AnimatedSprite2D

@export var damage: int = 500
var can_hit := true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_hit:
		can_hit = false
		$anim.play("pique")
		body.on_hit(damage)
		await get_tree().create_timer(0.5).timeout
		can_hit = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$anim.play("idle")
