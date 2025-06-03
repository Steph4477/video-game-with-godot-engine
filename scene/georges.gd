extends CharacterBody2D

@export var max_hp: int = 4000
var current_hp: int

var shoot: bool = false
const GRAVITY = 1000.0
const UP = Vector2(0, -1)
var spell = preload("res://scene/banane.tscn")
var can_fire: bool = true
var rate_of_fire: float = 0.4
var vel: Vector2 = Vector2.ZERO
@export var max_speed: int = 400
@export var JUMP_FORCE: int = -500
var coins: int = 0
var jump: bool = false
var jump_count: int = 0
var controleur_echelle: bool = false
var going_up: bool = false
var direction: int = 0
@export var climbing: bool = false

func _ready() -> void:
	$sounds/music.play()
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	movement_loop()
	skill_loop()
	
	animation_loop()
	velocity.y += GRAVITY * delta
	print(controleur_echelle)

func movement_loop() -> void:
	if is_on_floor():
		jump_count = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var saut = Input.is_action_just_pressed("ui_up")
	var dirx = int(right) - int(left)

	if dirx == 1:
		$sounds/walk.play()
		velocity.x = max_speed
		$Sprite.flip_h = false
		direction = 1
	elif dirx == -1:
		velocity.x = -max_speed
		$Sprite.flip_h = true
		direction = -1
	else:
		velocity.x = 0

	if saut and jump_count < 2:
		if jump_count == 0:
			$sounds/jump.pitch_scale = 0.7
		else:
			$sounds/jump.pitch_scale = 1.2
		$sounds/jump.play()

		velocity.y = JUMP_FORCE
		jump_count += 1
		if jump_count == 1:
			velocity.y = JUMP_FORCE

func animation_loop() -> void:
	if velocity.x != 0:
		$Sprite/Anim.play("walk")
		$sounds/walk.play()
	elif velocity.x == 0:
		$Sprite/Anim.play("idle")
	
	if jump_count == 1:
		$Sprite/Anim.play("jump_max")
	
	if velocity.y < 0:
		$Sprite/Anim.play("jump_max")
	elif velocity.y <= -300:
		$Sprite/Anim.play("jump_up")
	elif velocity.y > 0:
		$Sprite/Anim.play("jump_down")
	elif velocity.y >= 100:
		$Sprite/Anim.play("jump_att")
	elif velocity.y >= 600:
		$Sprite/Anim.play("jump_att2")
	
	if shoot:
		$anim.play("idle")

func skill_loop() -> void:
	if Input.is_action_pressed("shoot") and can_fire:
		can_fire = false
		$TurnAxis.rotation = get_angle_to(get_global_mouse_position())
		var spell_instance = spell.instantiate()
		$sounds/bullet.play()
		spell_instance.position = $TurnAxis/CastPoint.global_position
		spell_instance.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(spell_instance)
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true

func on_hit(damage: int) -> void:
	current_hp -= damage
	$HPBar.value = int((float(current_hp) / max_hp) * 100)
	
	if current_hp <= 0:
		on_death()

func on_death() -> void:
	$CollisionShape2D.disabled = true
	get_tree().reload_current_scene()

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ladder"):
		velocity.y = -1500
		$Sprite/Anim.play("echelle")

func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("Ladder"):
		controleur_echelle = false
		going_up = false
