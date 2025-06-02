extends KinematicBody2D
const GRAVITY =1000

const UP = Vector2 (0,-1)
export (int) var ACCEL = 20
var vel = Vector2()
#var jump_count = 0 
export (int) var max_speed = 200
export (int)var JUMP_FORCE = -500
#var coins = 0
var jump = false
#
func _physics_process(delta):
#	movement_loop ()
#	animation_loop ()
#	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, UP)
#
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
#	var jump = Input.is_action_just_pressed("ui_up")
##
#func movement_loop() :
##	if is_on_floor (): 
##		if jump == true :
##			vel.y = JUMP_FORCE
	var dirx = int(right) - int(left)
#
	if dirx == -1:
		vel.x= max_speed
		$Sprite.flip_h = true
	elif dirx == 1 :
		vel.x =  max_speed
		$Sprite.flip_h = false
	else :
		vel.x = 0
#
#	if jump == true and jump_count < 2 :
#		vel.y = JUMP_FORCE
#		jump_count += 1
#		print(jump_count)
#	if jump_count == 1 :
#		animation_play("jump_count")
#
#func animation_loop () :
#	if vel.x != 0 :
#		animation_play("walk")
#	if vel.x == 0 :
#		animation_play ("idle")
#	if vel.y < 0 :
#		animation_play ("jump_up")
#	if vel.y > 0 :
#		animation_play("jump_down")
#
#
#
#func animation_play(animation) :
#	if $anim.current_animation != animation :
#		$anim.play(animation)
