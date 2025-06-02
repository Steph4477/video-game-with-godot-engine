extends RigidBody2D
var speed = 300
var vel = Vector2()
var projectile_speed = 400
var life_time = 3
var damage = 10

func start (pos,dir) :
	randomize()
	position = pos
	vel = Vector2(speed * dir, randf_range(-30,30))
	


func _ready():
	apply_impulse(Vector2(),Vector2(projectile_speed,0).rotated(rotation))
	SelfDestruct()

func SelfDestruct() :
	await get_tree().create_timer(life_time).timeout

	queue_free()


func _on_Spell_body_entered(body):
	get_node("CollisionShape2D").set_deferred("disabled",true)
	if body.is_in_group("Player"):
		body.OnHit(damage)
	self.hide()

	pass # Replace with function body.
