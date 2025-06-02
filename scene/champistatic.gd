extends KinematicBody2D
const GRAVITY =1000
var current_hp
var max_hp = 40
const UP = Vector2 (0,-1)
export (int) var ACCEL = 20
var vel = Vector2()
var jump_count = 0 
export (int) var max_speed = 0
export (int)var JUMP_FORCE = -1500
var dirx = 0
var jump = false
var life = 100
var shoot = false
var bullet = preload ("res://scene/bullet2.tscn")
var damage = 1 
var direction = 1

func _on_Timer_timeout():
	var s = int(rand_range(0,10))
	if s <2 :
		shoot = true
	else :
		shoot = false
	var m = int(rand_range(0,10))
	if m<7:
		dirx = - 1
		$Sprite.flip_h = false
	elif m>7:
		dirx = 1
		$Sprite.flip_h = true
	else :
		dirx  = 0
	var j= int(rand_range(0,10))
	if j<2 :
		jump = true
	else :
		jump = false


func _physics_process(delta):
	movement_loop ()
#	animation_loop ()
	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, UP)

func movement_loop() :
	if is_on_floor (): 
		if jump == true :
			vel.y = JUMP_FORCE
	if dirx == -1:
		vel.x= max(vel.x - ACCEL, -max_speed)
		$Sprite.flip_h = false
		$muzzle2.position.x = -10
	elif dirx == 1 :
		vel.x = min(vel.x + ACCEL, max_speed)
		$Sprite.flip_h = true
		$muzzle2.position.x = 10
	else :
		vel.x = 0
		

	if shoot == true :
		var b = bullet.instance()
		b.start($muzzle2.global_position,1)
		get_parent().add_child(b)

##		animation_play("jump_count")
#	if jump_count == 1 :
#		animation_play("jump_up")
#	if vel.y > 0 :
#		animation_play("jump_down")

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
func _ready():
	current_hp = max_hp
func OnHit(_damage):
	current_hp -= damage
	get_node("HPBar").value = int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0 :
		OnDeath()

func OnDeath() :
	get_node("CollisionShape2D").set_deferred("disabled",true)
	#get_node("anim").play("xxx")
	
	queue_free ()
	
