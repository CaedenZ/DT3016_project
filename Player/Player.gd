extends KinematicBody2D


const MAXSPEED = 200
const DASHSPEED = 600
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY = 20
const MAX_JUMP_POWER = -600
const JUMP_POWER = -600

var speed := MAXSPEED
var direction := -1
var velocity := Vector2.ZERO
var jump_power := 0
var jumped := false
var wantstojump := false
var chargingjump := false
var can_attack := true
var life := 5
var stomped_on := false
var wantstodash := false
var previousdirection := 0
var dashing := false
var knockback := false
var dashoncooldown := false
var weaponNumber := 2
var attack := false
var count := 3
var gothit := false
var knockback_dir := 1
var knockbackevent := false

signal rangeAttack(playerid)

onready var dashtimer = $DashInputTimer
onready var dashdurationtimer = $DashDurationTimer
onready var dashcooldown = $DashCooldown
onready var knockbackeventtimer = $Knockbackevent
onready var statelabel = $StateLabel
onready var itemlabel = $ItemLabel
onready var lifelabel = $LifeLabel
onready var weaponcarriedA = $WeaponA
onready var weaponcarriedB = $WeaponB
onready var raycast = $RayCast2D
onready var animationplayer = $AnimationPlayer
onready var sprite = $Sprite
var jumpPart = preload("res://Particles/Jump.tscn")

signal update_life_ui(playerid)

func _ready():
	randomize()
	statelabel.text = "running"
	animationplayer.play("run")
	sprite.flip_h = true
	lifelabel.text = str(life)
	weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = true
	weaponcarriedA.connect("playerhit", self, "player_hit")
	itemlabel.text = str(weaponNumber)
func _physics_process(delta):
	if raycast.is_colliding() and !stomped_on:
		print("jumped on")
		take_damage(2)
		stomped_on = true
	elif !raycast.is_colliding():
		stomped_on = false
		
#	if Input.is_action_just_pressed("Left_A"):		
#		if wantstodash:
#			if previousdirection == -1 and !dashing:
#				if !dashoncooldown:
#					dashdurationtimer.start()
#					dashing = true
#					print("dashing left")
#		wantstodash = true
#		dashtimer.start()
#		previousdirection = -1
#	if Input.is_action_just_pressed("Left_A"):
#		if wantstodash:
#			if previousdirection == 1 and !dashing:
#				if !dashoncooldown:
#					dashdurationtimer.start()
#					dashing = true
#					print("dashing right")
#		wantstodash = true
#		dashtimer.start()
#		previousdirection = 1
#	if dashing:
#		speed = DASHSPEED


	if Input.is_action_just_pressed("Left_A"):
		direction *= -1
		sprite.flip_h = !sprite.flip_h
#	elif Input.is_action_pressed("Left_A"):
#		direction = 1
#		sprite.flip_h = false
	#else:
		#direction = 0
	if Input.is_action_just_pressed("Jump_A"):
		var new_particles = jumpPart.instance()
		new_particles.emitting = true
		if is_on_floor():
			velocity.y = JUMP_POWER
			if can_attack and !gothit:
				animationplayer.play("jump")
				new_particles.position = position
				var currentscene = get_tree().current_scene
				currentscene.add_child(new_particles)
	if Input.is_action_just_released("Jump_A"):
		var new_particles = jumpPart.instance()
		if !is_on_floor():
			if can_attack and !gothit:
				animationplayer.play("fall")
			if velocity.y < 0:
				velocity.y *= 0.5
				new_particles.position = position
				var currentscene = get_tree().current_scene
				currentscene.add_child(new_particles)
	if Input.is_action_just_pressed("Action_A"):
		attack()
#	if Input.is_action_just_pressed("ActionA"):
#		wantstojump = true
#		actiontimer.start()

#	if Input.is_action_just_released("ActionA"):
#		if !chargingjump:
#			wantstojump = false
#			attack()
#			actiontimer.stop()
#		else:
#			velocity.y = jump_power
#			wantstojump = false
#			chargingjump = false
#			statelabel.text = "jump"
#			jump_power = 0
		
		
#	if chargingjump:
#		jump_power -= 10
#		if jump_power < MAX_JUMP_POWER:
#			statelabel.text = "Max jump achieved"
#			jump_power = MAX_JUMP_POWER
#		print("jump_power:" + str(jump_power))
		
	if knockbackevent:
		if knockback:	
			velocity.x = knockback_dir * DASHSPEED
		elif(abs(velocity.x - direction * speed) > 50):
			velocity.x += (direction * speed - velocity.x) /20
			print(velocity.x)
		else:
			velocity.x = direction * speed
	else:
		velocity.x = direction * speed
		
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 3)
	velocity.y += GRAVITY
	#move_and_collide(velocity*delta)
	if is_on_floor():
		if can_attack and !gothit:
			animationplayer.play("run")
		if direction == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		jumped = false
		if statelabel.text == "jump":
			statelabel.text = "running"
	if position.x>1000:
		position.x=0
	if position.x<0:
		position.x=1000
	if position.y>600:
		position.y=0



func pickup():
	weaponNumber = randi() % 3
	print(weaponNumber)
	itemlabel.text = str(weaponNumber)
	if weaponNumber == 1:
		weaponcarriedA.show()
		weaponcarriedB.hide()
	elif weaponNumber == 2:
		weaponcarriedB.show()
		weaponcarriedA.hide()

func attack():
	if can_attack:
		match weaponNumber:
				0:
					print("We are number one!")
					emit_signal("rangeAttack", name)
				1:
					print("Two are better than one!")
					can_attack = false
					weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = false
					if !gothit:
						if direction == 1:
							animationplayer.play("attackright")
						elif direction == -1:
							animationplayer.play("attackleft")
					
					#cooldown.start()
				2:
					print("Oh snap! It's a string!")
					emit_signal("rangeAttack", name)



	


func _on_Hurtbox_area_entered(area):
	if global_position.x > area.global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	velocity.y = -300
	velocity.x = DASHSPEED * knockback_dir
	knockback = true
	dashdurationtimer.start()
	knockbackevent = true
	knockbackeventtimer.start()
	take_damage(1)
	gothit = true
	animationplayer.play("hit")

func refresh_hit_state():
	gothit = false
	
func take_damage(damage):
#	life -= damage
#	lifelabel.text = str(life)
	emit_signal("update_life_ui", name)
#	if life <= 0:
#		count -= 1
#		if count <= 0:
#			queue_free()
#		life = 5
#		position.x = 100
#		position.y = 200


func _on_DashTimer_timeout():
	wantstodash = false


func _on_DashDurationTimer_timeout():
	speed = MAXSPEED
	dashing = false
	dashoncooldown = true
	knockback = false
	dashcooldown.start()
	


func _on_DashCooldown_timeout():
	dashoncooldown = false

func end_attack():
	weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = true
	can_attack = true


func _on_Knockbackevent_timeout():
	knockbackevent = false
	pass # Replace with function body.
