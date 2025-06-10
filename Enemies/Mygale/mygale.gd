extends CharacterBody2D

@export var max_hp: int = 400
@onready var health_bar = $HealthBar/TextureProgressBar
@export var speed = 200
@export var attack_range = 610.0
@export var cooldown = 2.0

var can_shoot = true
var DeathEffect = preload("res://Effects/enemy_death_particles.tscn") 
var BaveFlac = preload("res://Loot/bave_flaque_static.tscn")
var projectile = preload("res://Tir/toile.tscn")
var current_hp: int
var frozen = false
var stone_coco = false
const GRAVITY = 2000.0
var damage = 200
var pv = max_hp
var is_attacking = false
var last_direction = 0
var player: Node2D

func _ready() -> void:
	current_hp = max_hp
	player = get_parent().get_node("player")
	print("player trouvé :", player)
	
func _physics_process(delta):
	if not player:
		return

	# Gravité
	apply_gravity(delta)

	# Se déplace vers le joueur
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	
	# Flip du sprite selon la direction
	$AnimatedSprite.flip_h = direction.x > 0

	if not is_attacking:
		if velocity.x != 0:
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")  # si tu as une anim idle

	
	# Tir
	var distance = global_position.distance_to(player.global_position)
	if distance < attack_range and can_shoot:
		velocity.x = 0  # Arrête-toi pour tirer
		await attack_and_shoot()

	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

func attack_and_shoot() -> void:
	can_shoot = false
	is_attacking = true

	$AnimatedSprite.play("attaque")

	# Calcule la durée exacte de l'animation
	var frames = $AnimatedSprite.sprite_frames.get_frame_count("attaque")
	var speed = $AnimatedSprite.sprite_frames.get_animation_speed("attaque")
	var anim_duration = frames / speed

	await get_tree().create_timer(anim_duration).timeout

	# Tirer ensuite
	var instance = projectile.instantiate()
	get_parent().add_child(instance)
	instance.global_position = global_position

	var dir = (player.global_position - global_position).normalized()
	instance.direction = dir

	await get_tree().create_timer(cooldown).timeout
	is_attacking = false
	can_shoot = true

# Dommage subie avec healthbar
func on_hit(damage: int) -> void:
	pv -= damage
	print("HealthBar scormard trouvée ? ", health_bar)
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.set_value(pv)
	print("PV restants : ", pv)
	show_damage_popup(damage)

func stone() -> void:
	if stone_coco:
		return
	stone_coco = true
	set_physics_process(false)
	$Timer.stop()
	$AnimatedSprite.play("stone")

	# 🧠 Calcule la durée réelle de l'animation
	var frames = $AnimatedSprite.sprite_frames.get_frame_count("stone")
	var speed = $AnimatedSprite.sprite_frames.get_animation_speed("stone")
	var anim_duration = frames / speed

	# 🔁 Attente basée sur la durée exacte de l'animation
	await get_tree().create_timer(anim_duration).timeout

	# ✅ Fin de l'état "stone"
	set_physics_process(true)
	$Timer.start()
	stone_coco = false

	## Reprise du déplacement
	#velocity.x = last_direction * SPEED
	#if velocity.x != 0:
		#$AnimatedSprite.play("walk")
	#else:
		#$AnimatedSprite.play("idle")

# Fonction stoppage par le player
func freeze() -> void:
	if frozen:
		return
	frozen = true
	set_physics_process(false)
	$Timer.stop()
	$AnimatedSprite.play("slide")
	
	# 🧠 Calcule la durée réelle de l'animation
	var frames = $AnimatedSprite.sprite_frames.get_frame_count("slide")
	var speed = $AnimatedSprite.sprite_frames.get_animation_speed("slide")
	var anim_duration = frames / speed

	# Glisse en arrière pendant cette durée
	var direction = -sign(velocity.x)
	if direction == 0:
		direction = -1  # recule par défaut
	var slide_distance = 100.0
	var slide_speed = slide_distance / anim_duration
	var elapsed := 0.0
	while elapsed < anim_duration:
		var delta := get_process_delta_time()
		position.x += direction * slide_speed * delta
		await get_tree().process_frame
		elapsed += delta

	# Fin de chute
	set_physics_process(true)
	$Timer.start()
	frozen = false
	
	# Reprendre le deplacement précedent
	#velocity.x = last_direction * SPEED
	#if velocity.x != 0:
		#$AnimatedSprite.play("walk")
	#else:
		#$AnimatedSprite.play("idle")

# Affichage des degats flotant
func show_damage_popup(amount: int) -> void:
	var popup = preload("res://ItemsDecors/damage_popup.tscn").instantiate()
	add_child(popup)
	popup.position = Vector2(0, -30)  # position flottante au-dessus du joueur
	popup.show_damage(amount)
	if pv <= 0:
		die()

# Mort
func die() -> void:
	print("Le scormard est mort !")
	
	# Cacher le Scormard tout de suite
	visible = false
	set_physics_process(false)

	# 💥 Particules de mort
	var particles = DeathEffect.instantiate()
	particles.global_position = global_position
	get_parent().add_child(particles)

	var cpu_particles = particles.get_node("CPUParticles2D")
	cpu_particles.emitting = true

	# 🔁 Attendre que les particules aient fini d’émettre
	await wait_for_particles_to_finish(cpu_particles)

	# 💧 Instancier la bave
	var bave = BaveFlac.instantiate()
	bave.global_position = global_position + Vector2(0, 10)
	get_tree().current_scene.add_child(bave)

	print("Bave ajoutée après particules !")
	print_tree()
	queue_free()

func wait_for_particles_to_finish(p: CPUParticles2D) -> void:
	# 🔁 Boucle jusqu’à ce que les particules s’arrêtent
	while p.emitting:
		await get_tree().process_frame

# Détection collision avec joueur
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not is_attacking:
		velocity.x = 0  # 🛑 Stoppe le mouvement
		await attack_and_shoot()

		# Applique les dégâts 
		if body.has_method("on_hit"):
			body.on_hit(damage)
