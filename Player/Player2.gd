extends KinematicBody2D


const SPEED = 200
const FLOOR_NORMAL = Vector2(0, -1)
const GRAVITY = 20
const MAX_JUMP_POWER = -600

var direction := 1
var velocity := Vector2.ZERO
var jump_power := 0
var jumped := false
var wantstojump := false
var chargingjump := false
var can_attack := true
var life := 5
var stomped_on := false

onready var actiontimer = $ActionTimer
onready var statelabel = $StateLabel
onready var itemlabel = $ItemLabel
onready var lifelabel = $LifeLabel
onready var weaponcarried = $WeaponA
onready var weapontimer = $WeaponTimer
onready var cooldown = $Cooldown
onready var raycast = $RayCast2D

func _ready():
	statelabel.text = "running"
	lifelabel.text = str(life)
	weaponcarried.get_node("Hitbox/CollisionShape2D").disabled = true
	weaponcarried.connect("playerhit", self, "player_hit")
	
func _physics_process(_delta):
	if raycast.is_colliding() and !stomped_on:
		print("jumped on")
		take_damage(2)
		stomped_on = true
	elif !raycast.is_colliding():
		stomped_on = false
		
	if Input.is_action_pressed("Left_B"):
		direction = -1
	elif Input.is_action_pressed("Right_B"):
		direction = 1
	else:
		direction = 0
	if Input.is_action_just_pressed("ActionB"):
		wantstojump = true
		actiontimer.start()

	if Input.is_action_just_released("ActionB"):
		if !chargingjump:
			wantstojump = false
			attack()
			actiontimer.stop()
		else:
			velocity.y = jump_power
			wantstojump = false
			chargingjump = false
			statelabel.text = "jump"
			jump_power = 0
		
		
	if chargingjump:
		jump_power -= 10
		if jump_power < MAX_JUMP_POWER:
			statelabel.text = "Max jump achieved"
			jump_power = MAX_JUMP_POWER
		print("jump_power:" + str(jump_power))
		
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 3)
	if is_on_floor():
		jumped = false
		if statelabel.text == "jump":
			statelabel.text = "running"


func _on_ActionTimer_timeout():
	if wantstojump:
		chargingjump = true
		jump_power = -50
		statelabel.text = "charging jump"

func pickup():
	var number = randi() % 10
	itemlabel.text = str(number)

func attack():
	if can_attack:
		can_attack = false
		weaponcarried.show()
		weaponcarried.get_node("Hitbox/CollisionShape2D").disabled = false
		if direction == 1:
			weaponcarried.position.x = abs(weaponcarried.position.x)
		elif direction == -1:
			weaponcarried.position.x = abs(weaponcarried.position.x) * -1
		
		weapontimer.start()
		#weaponcarried.hide()


	
func _on_WeaponTimer_timeout():
	weaponcarried.hide()
	weaponcarried.get_node("Hitbox/CollisionShape2D").disabled = true
	cooldown.start()


func _on_Hurtbox_area_entered(area):
	take_damage(1)

func take_damage(damage):
	life -= damage
	lifelabel.text = str(life)
	if life <= 0:
		queue_free()
		
func _on_Cooldown_timeout():
	can_attack = true
	pass # Replace with function body.
