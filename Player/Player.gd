extends KinematicBody2D


const MAXSPEED = 200
const DASHSPEED = 600
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY = 20
const MAX_JUMP_POWER = -500
const JUMP_POWER = -400

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
var dashoncooldown := false
var weaponNumber := 1
var count := 3

onready var actiontimer = $ActionTimer
onready var weapontimer = $WeaponTimer
onready var dashtimer = $DashInputTimer
onready var dashdurationtimer = $DashDurationTimer
onready var dashcooldown = $DashCooldown
onready var statelabel = $StateLabel
onready var itemlabel = $ItemLabel
onready var lifelabel = $LifeLabel
onready var weaponcarriedA = $WeaponA
onready var weaponcarriedB = $WeaponB
onready var cooldown = $Cooldown
onready var raycast = $RayCast2D
onready var animationplayer = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	statelabel.text = "running"
	animationplayer.play("run")
	sprite.flip_h = true
	lifelabel.text = str(life)
	weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = true
	weaponcarriedA.connect("playerhit", self, "player_hit")
	weaponcarriedB.get_node("Hitbox_ranged/CollisionShape2D").disabled = true
	weaponcarriedB.connect("playerhit", self, "player_hit")
	itemlabel.text = str(weaponNumber)
func _physics_process(delta):
	if raycast.is_colliding() and !stomped_on:
		print("jumped on")
		take_damage(2)
		stomped_on = true
	elif !raycast.is_colliding():
		stomped_on = false
		
	if Input.is_action_just_pressed("Left_A"):		
		if wantstodash:
			if previousdirection == -1 and !dashing:
				if !dashoncooldown:
					dashdurationtimer.start()
					dashing = true
					print("dashing left")
		wantstodash = true
		dashtimer.start()
		previousdirection = -1
	if Input.is_action_just_pressed("Right_A"):
		if wantstodash:
			if previousdirection == 1 and !dashing:
				if !dashoncooldown:
					dashdurationtimer.start()
					dashing = true
					print("dashing right")
		wantstodash = true
		dashtimer.start()
		previousdirection = 1
	if dashing:
		speed = DASHSPEED


	if Input.is_action_pressed("Left_A"):
		direction = -1
		sprite.flip_h = true
	elif Input.is_action_pressed("Right_A"):
		direction = 1
		sprite.flip_h = false
	#else:
		#direction = 0
	if Input.is_action_just_pressed("ActionA"):
		if is_on_floor():
			velocity.y = JUMP_POWER
			animationplayer.play("jump")
	if Input.is_action_just_released("ActionA"):
		if !is_on_floor():
			animationplayer.play("fall")
			if velocity.y < 0:
				velocity.y *= 0.5
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
		
	velocity.x = direction * speed
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 3)
	velocity.y += GRAVITY
	#move_and_collide(velocity*delta)
	if is_on_floor():
		animationplayer.play("run")
		if direction == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		jumped = false
		if statelabel.text == "jump":
			statelabel.text = "running"
	if position.x>640:
		position.x=0
	if position.x<0:
		position.x=640
	if position.y>360:
		position.y=0


func _on_ActionTimer_timeout():
	if wantstojump:
		chargingjump = true
		jump_power = -200
		statelabel.text = "charging jump"

func pickup():
	weaponNumber = randi() % 3
	print(weaponNumber)
	itemlabel.text = str(weaponNumber)

func attack():
	if can_attack:
		match weaponNumber:
				0:
					print("We are number one!")
				1:
					print("Two are better than one!")
					can_attack = false
					weaponcarriedA.show()
					weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = false
					if direction == 1:
						weaponcarriedA.position.x = abs(weaponcarriedA.position.x)
					elif direction == -1:
						weaponcarriedA.position.x = abs(weaponcarriedA.position.x) * -1
					weapontimer.start()
				2:
					print("Oh snap! It's a string!")
					#weaponcarriedB.show()
					#weaponcarriedB.get_node("Hitbox/CollisionShape2D").disabled = false
					#TODO: range weapon



	
func _on_WeaponTimer_timeout():
	weaponcarriedA.hide()
	weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = true
	cooldown.start()


func _on_Hurtbox_area_entered(area):
	take_damage(1)

func take_damage(damage):
	life -= damage
	lifelabel.text = str(life)
	if life <= 0:
		count -= 1
		if count <= 0:
			queue_free()
		life = 5
		position.x = 100
		position.y = 200

func _on_Cooldown_timeout():
	can_attack = true
	pass # Replace with function body.


func _on_DashTimer_timeout():
	wantstodash = false


func _on_DashDurationTimer_timeout():
	speed = MAXSPEED
	dashing = false
	dashoncooldown = true
	dashcooldown.start()
	


func _on_DashCooldown_timeout():
	dashoncooldown = false
