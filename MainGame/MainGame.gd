extends Node2D

var count
var gameTimer
onready var player = $Player
onready var player2 = $Player2
onready var player3 = $Player3
onready var player4 = $Player4
onready var p1_lives = $Lives/P1_lives
onready var p2_lives = $Lives/P2_lives
onready var p3_lives = $Lives/P3_lives
onready var p4_lives = $Lives/P4_lives
onready var itembox = $ItemBox

onready var bulletIns = preload("res://Items/Bullet.tscn")

func _ready():
	player.connect("rangeAttack", self, "generateBullet")
	itembox.connect("playertouch", self, "updateplayer")
	player.connect("update_life_ui", self, "updateplayerhealth")
	player2.connect("update_life_ui", self, "updateplayerhealth")
	player3.connect("update_life_ui", self, "updateplayerhealth")
	player4.connect("update_life_ui", self, "updateplayerhealth")
	p1_lives.connect("diedpermanently", self, "diepermanently")
	p2_lives.connect("diedpermanently", self, "diepermanently")
	p3_lives.connect("diedpermanently", self, "diepermanently")
	p4_lives.connect("diedpermanently", self, "diepermanently")
	count = 0
	gameTimer = $GameTimer

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://MainGame/MainGame.tscn")

func diepermanently(playerid):
	match playerid:
		"P1_lives":
			player.queue_free()
		"P2_lives":
			player2.queue_free()
		"P3_lives":
			player3.queue_free()
		"P4_lives":
			player4.queue_free()

func updateplayerhealth(playerid):
	match playerid:
		"Player":
			p1_lives.update_heartsprite()
		"Player2":
			p2_lives.update_heartsprite()
		"Player3":
			p3_lives.update_heartsprite()
		"Player4":
			p4_lives.update_heartsprite()

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
