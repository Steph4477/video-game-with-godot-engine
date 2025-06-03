extends RigidBody2D

var projectile_speed = 400
var life_time = 3
var damage = 90


func _ready():
	apply_impulse(Vector2(),Vector2(projectile_speed,0).rotated(rotation))
	SelfDestruct()

func SelfDestruct() :
	yield(get_tree().create_timer(life_time),"timeout")
	queue_free()


func _on_Spell_body_entered(body):
	get_node("CollisionShape2D").set_deferred("disabled",true)
	if body.is_in_group("Enemies") :
		body.OnHit(damage)
	elif body.is_in_group("Georges") :
		body.OnHit(damage)
	self.hide()

	pass # Replace with function body.
