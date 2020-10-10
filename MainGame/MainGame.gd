extends Node2D

var count
var gameTimer
onready var player = $Player
onready var player2 = $Player2
onready var itembox = $ItemBox

onready var bulletIns = preload("res://Items/Bullet.tscn")

func _ready():
	player.connect("rangeAttack", self, "generateBullet")
	count = 0
	gameTimer = $GameTimer

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://MainGame/MainGame.tscn")

func updateplayer(playerid):
	print(playerid)
	match playerid:
		"Player":
			print("Player 1 received")
			player.pickup()
		"Player2":
			print("Player 2 received")

func generateBullet(playerid):
	print(playerid)
	match playerid:
		"Player":
			print("Player 1 received")
			bulletShoot(playerid,player.global_position,player.direction)
		"Player2":
			print("Player 2 received")
			player2.pickup()
		"Player3":
			print("Player 3 received")
		"Player4":
			print("Player 4 received")

func bulletShoot(playerid,position,direction):
	var bullet = bulletIns.instance()
	var animationPlayer = bullet.get_child(0)
	var currentscene = get_tree().current_scene
	currentscene.add_child(bullet)
	match playerid:
		"Player":
			bullet.get_child(0).set_collision_mask_bit(4,false)
	bullet.position = position
	bullet.linear_velocity = Vector2(direction * 600, -100)
	

func _on_GameTimer_timeout():
	print("Time 20s")
	pass # Replace with function body.


func _on_ItemTimer_timeout():
	var Itembox = load("res://Items/ItemBox.tscn")
	var box = Itembox.instance()
	var currentscene = get_tree().current_scene
	currentscene.add_child(box)
	box.position.x = randi() % 640
	box.position.y = randi() % 360
	box.connect("playertouch", self, "updateplayer")
	pass # Replace with function body.
