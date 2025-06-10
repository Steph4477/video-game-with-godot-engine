extends CharacterBody2D

@export var speed := 800.0
@export var lifetime := 10.0
@onready var sprite = $anim
@onready var area = $Area2D

var direction: Vector2 = Vector2.ZERO
var has_collided = false
func _ready():
	sprite.play("attaque_toile")
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("CONTACT avec :", body.name)
	print("GROUPES :", body.get_groups())
	queue_free()
	if body.is_in_group("Player"):
		print("Le joueur a été touché par la toile !")
		has_collided = true

		var effet_scene = preload("res://effet_toile_collée.tscn")
		var effet = effet_scene.instantiate()
		
		get_tree().current_scene.add_child(effet)
		effet.global_position = global_position
		effet.get_node("AnimationPlayer").play("appear_fade")
		# Applique l’effet au joueur
		if body.has_method("apply_web_effect"):
			body.apply_web_effect()

			queue_free()
