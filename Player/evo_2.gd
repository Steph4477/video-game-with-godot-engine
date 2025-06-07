extends CharacterBody2D

@export var speed = 500
@export var jump_force = -900
@export var gravity = 1200
@export var max_pv = 2500
@onready var health_bar = $HealthBar/TextureProgressBar
@onready var banana_label = get_node("../Hud/HBoxContainer/BananeCountLabel")
var jump_count = 0
var pv = max_pv
# Contrôle via UI
var moving_left = false
var moving_right = false
var jumping = false
# Option tir
var banana_count = 0
var spell = preload ("res://Tir/banane.tscn")
var can_fire = false  # Tir désactivé au début
var rate_of_fire = 0.4
var moving_down = false
var coin = 0
var is_climbing = false
var climb_speed = 100.0
var can_climb = false

func set_can_climb(value: bool) -> void:
	can_climb = value
	if !value:
		is_climbing = false

func _ready():
	$Camera2D.make_current()

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


	# Détecter si on est en train de grimper
		print(can_climb)
	if can_climb and Input.is_action_pressed("ui_up"):
		is_climbing = true
	elif !can_climb:
		is_climbing = false

	# Appliquer mouvement vertical(escalade)
	if is_climbing:
		# On grimpe
		velocity.y = 0  # neutralise la gravité
		if Input.is_action_pressed("ui_up"):
			velocity.y = -climb_speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = climb_speed
	else:
		# On ne grimpe pas → vérifier saut
		if (Input.is_action_just_pressed("ui_up") or jumping) and jump_count < 2:
			velocity.y = jump_force
			jump_count += 1
			jumping = false
		else:
			# Appliquer gravité si pas de saut
			velocity.y += gravity * delta

	# Appliquer mouvement
	move_and_slide()

	# Animation
	update_animation()
	
	# Tir
	if Input.is_action_pressed("ui_accept") and can_fire:
		SkillLoop()

func update_animation() -> void:
	if is_climbing:
		$anim.play("climb")
		return # Empêche de passer aux conditions suivantes !
	if velocity.y < 0:
		$anim.play("jump_up")
	elif velocity.y > 0:
		$anim.play("jump_down")
	elif velocity.x != 0:
		$anim.play("walk")
	else:
		$anim.play("idle")

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

func update_banana_display():
	if banana_label:
		banana_label.text = "x %d" % banana_count

# Fonction de tir
func collect_banana(amount: int = 1, enable_shooting: bool = false) -> void:
	banana_count += amount
	update_banana_display()
	print("🍌 Bananes collectées :", banana_count)

	if enable_shooting:
		can_fire = true
		print("✅ Tir activé !")

func SkillLoop() -> void:
	# Tir bloqué
	if !Input.is_action_pressed("ui_accept") or !can_fire:
		return
	if banana_count <= 0:
		print("❌ Plus de bananes, le tir est bloqué.")
		can_fire = false
		return
	can_fire = false
	# Tir activé
	banana_count -= 1
	update_banana_display()
	print("🍌 Le joueur tire une banane ! Restantes :", banana_count)
	
	var spell_instance = spell.instantiate()
	#$sounds/box.play()
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
#func _on_left_pressed() -> void:
	#moving_left = true
#func _on_left_released() -> void:
	#moving_left = false
#
#func _on_right_pressed() -> void:
	#moving_right = true
#func _on_right_released() -> void:
	#moving_right = false
#
#func _on_jump_pressed() -> void:
	#jumping = true
#func _on_jump_released() -> void:
	#jumping = false
#
#func _on_down_pressed() -> void:
	#moving_down = true
#func _on_down_released() -> void:
	#moving_down = false
#
#func _on_shoot_released() -> void:
	#pass # Replace with function body.
#func _on_shoot_pressed() -> void:
	#pass # Replace with function body.
