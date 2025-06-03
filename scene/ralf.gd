extends KinematicBody2D

export (int) var max_hp = 4000
var current_hp

var shoot = false
const GRAVITY =1000
const UP = Vector2 (0,-1)
var spell = preload ("res://scene/banane.tscn")
var can_fire = true
var rate_of_fire = 0.4
var vel = Vector2()
export (int) var max_speed = 400
export (int)var JUMP_FORCE = -500
var coins = 0
var jump = false
var jump_count = 0

var direction = 0



func _physics_process(delta):
	movement_loop ()
	SkillLoop()
	vel = move_and_slide(vel, UP)
	animation_loop()
	vel.y += GRAVITY * delta

func movement_loop () : 
	if is_on_floor() :
		jump_count = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_up")
	var shoot = Input.is_action_pressed("ui_select")
	var dirx = int(right) - int (left)

	if dirx == 1:
		vel.x = max_speed
#		$muzzle3.position.x =  20
		$anim.flip_h = false
		direction = 1
	elif dirx == -1 :
		vel.x = -max_speed
#		$muzzle3.position.x = -40
		$anim.flip_h = true
		direction = -1
	else :
		vel.x = 0
	if jump == true and jump_count < 2  :
		vel.y = -750
		jump_count += 1
		if jump_count == 1 :
			vel.y = -500

func animation_loop ():
	if vel.x != 0 :
		$anim.play("walk")
	if vel.x == 0 :
		$anim.play("idle")
	if vel.y < 0 :
		$anim.play("jump_count")
	if jump_count == 1 :
		$anim.play("jump_up")
	if vel.y > 0 :
		$anim.play("jump_down")
	if shoot == true :
		$anim.play("idle")
		
		
func SkillLoop() :
	if Input.is_action_pressed("shoot") and can_fire == true :
		can_fire = false
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		var spell_instance = spell.instance()
		spell_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
		spell_instance.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(spell_instance)
		yield(get_tree().create_timer(rate_of_fire),"timeout")
		can_fire = true
		

func _ready():
	current_hp = max_hp

func OnHit(damage):
	current_hp -= damage
	get_node("HPBar").value = int((float(current_hp) / max_hp) * 100) 
	$anim.play("dead")	
	if current_hp <= 0 :
		OnDeath()

func OnDeath() :
	get_node("CollisionShape2D").set_deferred("disabled",true)
	get_tree().reload_current_scene()
	$anim.play("dead")
