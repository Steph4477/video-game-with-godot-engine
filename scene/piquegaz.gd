extends AnimatedSprite
var life = 100000
func hit (damage):
	life -= damage
	if life <= 0 :
		queue_free()


func _ready():
	pass



	


func _on_Area2D_body_entered(body):
	queue_free()
