extends CharacterBody2D

@export var speed = 500
@export var jump_force = -1200
@export var gravity = 1200
@export var pv = 2000
@onready var health_bar = $HealthBar/TextureProgressBar
@onready var banane_label = get_node("../Hud/HBoxContainerBanane/BananeCountLabel")
@onready var coco_label = get_node("../Hud/HBoxContainerCoco/CocoCountLabel")

# Initialisation des variables du GameState
var game_state
var can_fire_banane  # Tir désactivé au début
var banane_count 
var can_fire_coco # Tir désactivé au début
var coco_count
# Double Saut
var jump_count = 0
# tir
var spellBanane = preload ("res://Tir/banane.tscn")
var spellCoco = preload ("res://Tir/coco.tscn")
var rate_of_fire = 0.4
# escalade
var is_climbing = false
var is_climbingCoco = false
var climb_speed = 100.0
var can_climb = false
var can_climbCoco = false
# Contrôle via UI
var moving_left = false
var moving_right = false
var jumping = false
var moving_down = false

func set_can_climb(value: bool) -> void:
	can_climb = value
	if !value:
		is_climbing = false

func set_can_climbCoco(value: bool) -> void:
	can_climbCoco = value
	if !value:
		is_climbingCoco = false

func _ready():
	$Camera2D.make_current()
	await get_tree().process_frame  # attend une frame pour que la scene courante soit prête
	game_state = get_tree().current_scene.get_node("../GameState")
	
	if game_state:
		print("✅ GameState trouvé :", game_state)
		# Initialisation depuis GameState
		banane_count = game_state.banane_count
		coco_count = game_state.coco_count
		can_fire_banane = game_state.can_fire_banane
		can_fire_coco = game_state.can_fire_coco
	else:
		print("❌ GameState introuvable")

func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jump_count = 0

	# Direction par InputMap (clavier/manette)
	var direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	## Avec boutons UI
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

	# Détecter si on est en train de grimper sur bananier
	if can_climb and Input.is_action_pressed("ui_up"):
		is_climbing = true
	elif !can_climb:
		is_climbing = false
	
	# Détecter si on est en train de grimper sur cocotier
	if can_climbCoco and Input.is_action_pressed("ui_up"):
		is_climbingCoco = true
	elif !can_climbCoco:
		is_climbingCoco = false
	

	# Appliquer mouvement vertical(escalade bananier)
	if is_climbing:
		# On grimpe
		velocity.y = 0  # neutralise la gravité
		if Input.is_action_pressed("ui_up"):
			velocity.y = -climb_speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = climb_speed
		
	# Appliquer mouvement vertical(escalade cocotier)
	if is_climbingCoco:
		# On grimpe
		velocity.y = 0  # neutralise la gravité
		if Input.is_action_pressed("ui_up"):
			velocity.y = -climb_speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = climb_speed
	else:
		# On ne grimpe pas → vérifier saut
		if Input.is_action_just_pressed("ui_up") and jump_count < 2:
		#if (Input.is_action_just_pressed("ui_up") or jumping) and jump_count < 2: # Avec UI
			velocity.y = jump_force
			jump_count += 1
			#jumping = false # Avec UI
		else:
			# Appliquer gravité si pas de saut
			velocity.y += gravity * delta

	# Appliquer mouvement
	move_and_slide()

	# Animation
	update_animation()
	
	# Tir
	if Input.is_action_pressed("ui_accept") and can_fire_banane:
		SkillLoop()
	if Input.is_action_pressed("ui_cancel") and can_fire_coco:
		SkillLoop()

func update_animation() -> void:
	if is_climbing:
		$anim.play("climb")
		return # Empêche de passer aux conditions suivantes !
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		is_climbingCoco = false
		velocity.y = 0 #Fait tomber du cocotier !
	if is_climbingCoco:
		$anim.play("climb_coco")
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
		health_bar.max_value = pv
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

func update_banane_display():
	if banane_label:
		banane_label.text = "x %d" % banane_count

func update_coco_display():
	if coco_label:
		coco_label.text = "x %d" % coco_count

# Fonction de collecte
func collect_banane(amount: int = 1, enable_shooting: bool = false) -> void:
	banane_count += amount
	# Activation du tir
	if enable_shooting:
		can_fire_banane = true
		print("✅ Tir activé !")
	# Récuperation des données des variables de GameState
	if game_state:
		game_state.can_fire_banane = can_fire_banane
		game_state.banane_count = banane_count
		print("✅ Banane_count = :", game_state.banane_count)
		print("✅ Can_fire_banane = :", game_state.can_fire_banane)
	#mise a jour de l'HUD
	update_banane_display()
	print("🍌 Bananes collectées :", banane_count)

func collect_coco(amount: int = 1, enable_shooting: bool = false) -> void:
	coco_count += amount
	# Activation du tir
	if enable_shooting:
		can_fire_coco = true
		print("✅ Tir activé !")
	# Récuperation des données des variables de GameState
	if game_state:
		game_state.can_fire_coco = can_fire_coco
		game_state.coco_count = coco_count
		print("✅ Coco_count = :", game_state.coco_count)
		print("✅ Can_fire_coco = :", game_state.can_fire_coco)
	#mise a jour de l'HUD
	update_coco_display()
	print("🥥 Coco collectées :", coco_count)

# Fonction de Tir
func SkillLoop() -> void:
	#direction du tir
	var direction: int
	if $anim.flip_h:
		direction = -1
	else:
		direction = 1

	# config touche tir de banane (ui_accept)
	if Input.is_action_just_pressed("ui_accept") and can_fire_banane:
		if banane_count > 0:
			#can_fire_coco = false
			banane_count -= 1
			update_banane_display()
			# ✅ Met à jour GameState après la modification
			if game_state:
				game_state.banane_count = banane_count

			print("🍌 Tir banane ! Restantes :", banane_count)
			# instancie la scene de munition de banane à l'endroit du joueur
			var banane_spell = spellBanane.instantiate()
			#$sounds/box.play()
			var spawn_pos = get_node("TurnAxis/CastPoint").get_global_position()
			banane_spell.start(spawn_pos, direction)
			get_tree().current_scene.add_child(banane_spell)
			await get_tree().create_timer(rate_of_fire).timeout
			can_fire_banane = true
		else:
			print("❌ Plus de bananes !")

	# config touche tir de coco (ui_cancel)
	elif Input.is_action_just_pressed("ui_cancel") and can_fire_coco:
		if coco_count > 0:
			#can_fire_coco = false
			coco_count -= 1
			update_coco_display()
			# ✅ Met à jour GameState après la modification
			if game_state:
				game_state.coco_count = coco_count

			print("🥥 Tir coco ! Restantes :", coco_count)
			# instancie la scene de munition de coco à l'endroit du joueur
			var coco_spell = spellCoco.instantiate()
			var spawn_pos = get_node("TurnAxis/CastPoint").get_global_position()
			coco_spell.start(spawn_pos, direction)
			get_tree().current_scene.add_child(coco_spell)
			await get_tree().create_timer(rate_of_fire).timeout
			can_fire_coco = true
		else:
			print("❌ Plus de cocos !")

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
