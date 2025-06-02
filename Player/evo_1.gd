extends CharacterBody2D

@export var speed = 800
@export var jump_force = -1200
@export var gravity = 1200
@export var max_pv = 2000
@onready var health_bar = $HealthBar/TextureProgressBar

var jump_count = 0
var pv = max_pv
# Contrôle via UI
var moving_left = false
var moving_right = false
var jumping = false
# Option tir
var spell = preload ("res://Tir/banane.tscn")
var can_fire = true
var shooting = false
var rate_of_fire = 0.4
var moving_down = false
var coin = 0

func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jump_count = 0

	# Direction par InputMap (clavier/manette)
	var direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Avec boutons UI
	if moving_left:
		direction = -1
	elif moving_right:
		direction = 1
	velocity.x = direction * speed

	# Flip sprite
	if direction > 0:
		$anim.flip_h = false
	elif direction < 0:
		$anim.flip_h = true

	# Saut via InputMap ou bouton
	if (Input.is_action_just_pressed("ui_up") or jumping) and jump_count < 2:
		velocity.y = jump_force
		jump_count += 1
		jumping = false  # on saute une seule fois par clic

	# Appliquer mouvement
	move_and_slide()

	# Animation
	update_animation()
	
	# Tir
	# SkillLoop()
	if Input.is_action_pressed("shoot") and can_fire:
		SkillLoop()

func update_animation() -> void:
	if velocity.y < 0:
		$anim.play("jump_up")
	elif velocity.y > 0:
		$anim.play("jump_down")
	elif velocity.x != 0:
		$anim.play("walk")
	else:
		$anim.play("idle")
	# Remplace si "shoot"
	if shooting:
		$anim.play("idle")  # Remplace si "shoot"

func on_hit(damage: int) -> void:
	pv -= damage
	print("HealthBar trouvé ? ", health_bar)
	if health_bar:
		health_bar.max_value = max_pv
		health_bar.set_value(pv)
	print("PV restants : ", pv)
	show_damage_popup(damage)
	
func show_damage_popup(amount: int) -> void:
	var popup = preload("res://ItemsDecors/damage_popup.tscn").instantiate()
	add_child(popup)
	popup.position = Vector2(0, -30)  # position flottante au-dessus du joueur
	popup.show_damage(amount)

	if pv <= 0:
		die()

func die() -> void:
	print("Le joueur est mort !")
	get_tree().reload_current_scene()

# Fonction de tir
func SkillLoop() -> void:
	if Input.is_action_pressed("shoot") and can_fire:
		print("Le joueur tir !")
		can_fire = false
		var spell_instance = spell.instantiate()
		##$sounds/bullet.play()
		var spawn_pos = get_node("TurnAxis/CastPoint").get_global_position()
		var direction: int
		if $anim.flip_h:
			direction = -1
		else:
			direction = 1
		spell_instance.start(spawn_pos, direction)
		get_tree().current_scene.add_child(spell_instance)
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true

# --- Signaux boutons UI ---
func _on_left_pressed() -> void:
	moving_left = true
func _on_left_released() -> void:
	moving_left = false

func _on_right_pressed() -> void:
	moving_right = true
func _on_right_released() -> void:
	moving_right = false

func _on_jump_pressed() -> void:
	jumping = true
func _on_jump_released() -> void:
	jumping = false

func _on_down_pressed() -> void:
	moving_down = true
func _on_down_released() -> void:
	moving_down = false

func _on_shoot_released() -> void:
	pass # Replace with function body.
func _on_shoot_pressed() -> void:
	pass # Replace with function body.
