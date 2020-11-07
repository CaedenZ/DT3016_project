extends KinematicBody2D

const MAXSPEED = 165
const SPEED1 = 165
const SPEED2 = 265
const SPEED3 = 365
const DASHSPEED = 600
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY = 20
const MAX_JUMP_POWER = -600
const JUMP_POWER = -400

var speed := SPEED1
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
var weaponNumber := 0
var attack := false
var count := 3
var gothit := false
var knockback_dir := 1
var knockbackevent := false
var durability := 0
var candoublejump := false
var max_hp = 12

var leftbutton = "Left_A"
var rightbutton = "Right_A"
var jumpbutton = "Jump_A"
signal rangeAttack(playerid)
signal hitwatermelon(playerid, watermelon)

onready var dashtimer = $DashInputTimer
onready var dashdurationtimer = $DashDurationTimer
onready var dashcooldown = $DashCooldown
onready var knockbackeventtimer = $Knockbackevent
onready var statelabel = $StateLabel
onready var itemlabel = $ItemLabel
onready var lifelabel = $LifeLabel
onready var weaponcarriedA = $WeaponA
onready var weaponcarriedB = $WeaponB
onready var weaponcarriedC = $WeaponC

onready var bombtimer1 = $WeaponC/FirstStateTimer
onready var bombtimer2 = $WeaponC/SecondStateTimer
onready var bombtimer3 = $WeaponC/ThirdStateTimer

onready var bombblinkTimer = $WeaponC/BlinkTimer

onready var raycast = $RayCast2D
onready var animationplayer = $AnimationPlayer
onready var sprite = $Sprite
var jumpPart = preload("res://Particles/Jump.tscn")
onready var jumpSound = $Jump
onready var heartsprite = $LifeManager/HP
onready var lifecounter = $LifeManager/Lives


signal update_life_ui(playerid)
signal diedpermanently(playerid)
signal onExplosion(playerid)

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
		

	if Input.is_action_just_pressed(leftbutton):
		if direction == 1:
			direction = -1
			sprite.flip_h = !sprite.flip_h
			weaponcarriedA.position = Vector2(23, -8)
			weaponcarriedB.position.x *= -1
			weaponcarriedA.flip_h = false
			weaponcarriedB.flip_h = false
		else:
			#do action
			attack()
			print("attack")
	elif Input.is_action_just_pressed(rightbutton):
		if direction == -1:
			direction = 1
			sprite.flip_h = !sprite.flip_h
			weaponcarriedA.position = Vector2(-23, -8)
			weaponcarriedB.position.x *= -1
			weaponcarriedA.flip_h = true
			weaponcarriedB.flip_h = true
			print("change direction")
		else:
			#do action
			attack()
			print("attack")
	if Input.is_action_just_pressed(jumpbutton):
		var new_particles = jumpPart.instance()
		new_particles.emitting = true
		if is_on_floor():
			velocity.y = JUMP_POWER
			candoublejump = true
			if can_attack and !gothit:
				animationplayer.play("jump")
				jumpSound.play()
				new_particles.position = position
				var currentscene = get_tree().current_scene
				currentscene.add_child(new_particles)
		elif candoublejump:
			velocity.y = JUMP_POWER
			candoublejump = false
			if can_attack and !gothit:
				animationplayer.play("jump")
				jumpSound.play()
				new_particles.position = position
				var currentscene = get_tree().current_scene
				currentscene.add_child(new_particles)
	if Input.is_action_just_released(jumpbutton):
		var new_particles = jumpPart.instance()
		if !is_on_floor():
			if can_attack and !gothit:
				animationplayer.play("fall")
			if velocity.y < 0:
				velocity.y *= 0.5
				new_particles.position = position
				var currentscene = get_tree().current_scene
				currentscene.add_child(new_particles)
#	if Input.is_action_just_pressed("Action_A"):
#		attack()
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
			#print(velocity.x)
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
	var random_number = randi() % 6 + 1
	if random_number > 4:
		weaponNumber = 1
	elif random_number > 3:
		weaponNumber = 2
	else:
		weaponNumber = random_number
	print(weaponNumber)
	itemlabel.text = str(weaponNumber)
	if weaponNumber == 0:
		weaponcarriedA.hide()
		weaponcarriedB.hide()
		weaponcarriedC.hide()
	if weaponNumber == 1:
		weaponcarriedA.show()
		weaponcarriedB.hide()
		durability = 10
	elif weaponNumber == 2:
		weaponcarriedB.show()
		weaponcarriedA.hide()
		durability = 5
	elif weaponNumber == 3:
		weaponcarriedC.show()
		weaponcarriedB.hide()
		weaponcarriedA.hide()
		bombtimer1.start()
		bombblinkTimer.start()

func attack():
	if can_attack:
		match weaponNumber:
				0:
					#print("We are number one!")
					pass
				1:
					#print("Two are better than one!")
					can_attack = false
					weaponcarriedA.get_node("Hitbox/CollisionShape2D").disabled = false
					#if !gothit:
					durability -= 1
					if direction == 1:
						animationplayer.play("attackright")
					elif direction == -1:
						animationplayer.play("attackleft")
						
					
					#cooldown.start()
				2:
					#print("Oh snap! It's a string!")
					emit_signal("rangeAttack", name)
					durability -= 1
					checkdurability()
					
	if weaponcarriedC.visible == true:
		print("pass")

func checkdurability():
	if durability <= 0:
		weaponNumber = 0
		weaponcarriedA.hide()
		weaponcarriedB.hide()


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

func update_heartsprite():
	if max_hp > 0:
		heartsprite.frame += 1
		max_hp -= 1
		update_counter()
		update_speed()
		
func update_counter():
	lifecounter.text = "X" + str(max_hp)
	if max_hp % 4 == 0 and max_hp > 0:
		heartsprite.frame = 0
	elif max_hp == 0:
		emit_signal("diedpermanently", name)

func update_speed():
	if max_hp <= 6 and max_hp > 2:
		speed = SPEED2
	elif max_hp <=2:
		speed = SPEED3

func _on_DashTimer_timeout():
	wantstodash = false


func _on_DashDurationTimer_timeout():
	update_speed()
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

func reposition_sword():
	if direction: #right
		weaponcarriedA.position = Vector2(-23,-8)
		weaponcarriedA.flip_h = true
	else: #left
		weaponcarriedA.position = Vector2(23,-8)
		weaponcarriedA.flip_h = false


func _on_FirstStateTimer_timeout():
	bombblinkTimer.wait_time = 0.5
	bombtimer2.start()

func _on_SecondStateTimer_timeout():
	bombblinkTimer.wait_time = 0.1
	bombtimer3.start()


func _on_ThirdStateTimer_timeout():
	bombblinkTimer.wait_time = 1
	bombblinkTimer.stop()
	emit_signal("onExplosion", name)
	weaponcarriedC.hide()


func _on_BlinkTimer_timeout():
	if weaponcarriedC.modulate.a == 1:
		weaponcarriedC.modulate.a = 0.5
	elif weaponcarriedC.modulate.a == 0.5:
		weaponcarriedC.modulate.a = 1


func _on_Hitbox_body_entered(body):
	if body.is_in_group("bullet"):
		body.linear_velocity = Vector2(direction * 600, -300)
		emit_signal("hitwatermelon", name, body)
		
