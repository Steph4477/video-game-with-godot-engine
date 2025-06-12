extends CharacterBody2D

const GRAVITY = 1000.0
const UP = Vector2.UP

@export var max_hp: int = 400
@export var SPEED: int = 200.0
@export var JUMP_FORCE: int = -1500

@onready var health_bar = $HealthBar/TextureProgressBar
@onready var muzzle: Node2D = $muzzle2
@onready var sprite: Sprite2D = $Sprite

var pv = max_hp
var current_hp: int
var vel: Vector2 = Vector2.ZERO
var dirx: int = 0
var jump: bool = false
var shoot: bool = false
var damage: int = 100
var direction: int = 1  # 1 = droite, -1 = gauche
var gaz = preload("res://Tir/gaz.tscn")

func _ready():
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	vel.y += GRAVITY * delta

func _on_Timer_timeout() -> void:
	velocity = vel
	var s = randi_range(0, 9)
	shoot = s < 9
	if shoot:
		var b = gaz.instantiate()
		b.start(muzzle.global_position, direction)
		get_parent().add_child(b)

	var m = randi_range(0, 9)
	if m < 3:
		dirx = -1
		vel.x = -SPEED
		sprite.flip_h = false
	elif m > 6:
		dirx = 1
		vel.x = SPEED
		sprite.flip_h = true
	else:
		vel.x = 0

	jump = randi_range(0, 9) < 2

func on_hit(damage: int) -> void:
	pv -= damage
	print("HealthBar champi trouvée ? ", health_bar)
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.set_value(pv)
	print("PV restants : ", pv)
	show_damage_popup(damage)
	
# Affichage des degats flotant
func show_damage_popup(amount: int) -> void:
	var popup = preload("res://ItemsDecors/damage_popup.tscn").instantiate()
	add_child(popup)
	popup.position = Vector2(0, -30)  # position flottante au-dessus
	popup.show_damage(amount)
	if pv <= 0:
		die()

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.is_in_group("Player"):
			if body.has_method("on_hit"):
				body.on_hit(damage)
