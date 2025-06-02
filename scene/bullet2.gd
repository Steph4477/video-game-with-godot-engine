#extends RigidBody2D
#var speed = 300
#var vel = Vector2()
#var projectile_speed = 400
#var life_time = 3
#var damage = 10
#
#func start (pos,dir) :
	#randomize()
	#position = pos
	#vel = Vector2(speed * dir, randf_range(-30,30))
	#
#func _ready():
	#apply_impulse(Vector2(),Vector2(projectile_speed,0).rotated(rotation))
	#SelfDestruct()
#
#func SelfDestruct() :
	#await get_tree().create_timer(life_time).timeout
	#queue_free()
	#
#func _on_Spell_body_entered(body):
	#get_node("CollisionShape2D").set_deferred("disabled",true)
	#if body.is_in_group("Player"):
		#body.OnHit(damage)
	#self.hide()
	#pass # Replace with function body.
extends RigidBody2D

@export var speed := 30.0
@export var lifetime := 2.0
@export var scale_growth := 1.5
@export var growth_speed := 0.4

var direction := 1
var time_passed := 0.0
var started := false

func start(pos: Vector2, dir: int) -> void:
	position = pos
	direction = dir
	scale = Vector2(0.2, 0.2)
	started = true

	# Appliquer une impulsion vers le haut pour faire monter
	apply_impulse(Vector2.ZERO, Vector2(0, -150))  # Tu peux ajuster la force

func _physics_process(delta: float) -> void:
	if not started:
		return

	time_passed += delta

	# S'agrandit progressivement
	if scale.x < scale_growth:
		scale += Vector2(growth_speed, growth_speed) * delta

	# Se détruit après un certain temps
	if time_passed > lifetime:
		queue_free()
