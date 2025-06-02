extends AnimatedSprite

export (int) var damage = 500

func _on_Area2D_body_entered(body):
	#get_node("Area2D/CollisionShape2D")
	if body.is_in_group("Player"):
		$anim.play("pique")
		body.OnHit(damage)
	
	


#func _on_Area2D_body_exited(body):
	#play("idle")
	pass # Replace with function body.



