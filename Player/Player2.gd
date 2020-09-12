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

onready var actiontimer = $ActionTimer
onready var statelabel = $StateLabel

func _ready():
	statelabel.text = "running"
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ChangeDirectionB"):
		direction *= -1
	if Input.is_action_just_pressed("ActionB"):
		wantstojump = true
		actiontimer.start()

	if Input.is_action_just_released("ActionB"):
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
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	if is_on_floor():
		jumped = false
		if statelabel.text == "jump":
			statelabel.text = "running"


func _on_ActionTimer_timeout():
	if wantstojump:
		chargingjump = true
		statelabel.text = "charging jump"
