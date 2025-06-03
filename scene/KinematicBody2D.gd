extends KinematicBody2D


const GRAVITY =1000
const UP = Vector2 (0,-1)
var bullet = preload ("res://scene/bullet.tscn")
var shoot = false
var vel = Vector2()
export (int) var max_speed = 400
export (int)var JUMP_FORCE = -500
var coins = 0
var jump = false
var jump_count = 0
var life = 1000
var direction = 0
func _physics_process(delta):
	movement_loop ()
	vel = move_and_slide(vel, UP)
	animation_loop()
	vel.y += GRAVITY * delta

func movement_loop () : 
	if is_on_floor() :
		jump_count = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_up")
	var shoot = Input.is_action_just_pressed("ui_select")
	var dirx = int(right) - int (left)

	if dirx == 1:
		vel.x = max_speed
		$muzzle3.position.x =  20
		$anim.flip_h = false
		direction = 1
	elif dirx == -1 :
		vel.x = -max_speed
		$muzzle3.position.x = -40
		$anim.flip_h = true
		direction = -1
	else :
		vel.x = 0
	if jump == true and jump_count < 2  :
		vel.y = -750
		jump_count += 1
		if jump_count == 1 :
			vel.y = -500
	if shoot == true :
		var b = bullet.instance ()
		b.start($muzzle3.global_position,direction)
		get_parent().add_child(b)

	

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



func hit (damage):
	life -= damage
	if life <= 0 :
		get_tree().reload_current_scene()


