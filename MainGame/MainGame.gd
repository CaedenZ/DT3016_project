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
onready var itemspawn = $ItemSpawn
onready var bulletIns = preload("res://Items/Bullet.tscn")
var confetti = preload("res://Items/Confetti.tscn")

onready var explosionIns = preload("res://Items/Explosion.tscn")

func _ready():
	player.connect("rangeAttack", self, "generateBullet")
	player2.connect("rangeAttack", self, "generateBullet")
	player3.connect("rangeAttack", self, "generateBullet")
	player4.connect("rangeAttack", self, "generateBullet")
	itembox.connect("playertouch", self, "updateplayer")
	player.connect("update_life_ui", self, "updateplayerhealth")
	player2.connect("update_life_ui", self, "updateplayerhealth")
	player3.connect("update_life_ui", self, "updateplayerhealth")
	player4.connect("update_life_ui", self, "updateplayerhealth")
	player.connect("diedpermanently", self, "diepermanently")
	player2.connect("diedpermanently", self, "diepermanently")
	player3.connect("diedpermanently", self, "diepermanently")
	player4.connect("diedpermanently", self, "diepermanently")
	player.connect("onExplosion", self, "generateExplosion")
	player2.connect("onExplosion", self, "generateExplosion")
	player3.connect("onExplosion", self, "generateExplosion")
	player4.connect("onExplosion", self, "generateExplosion ")
	player.connect("passbomb", self, "passbomb")
	player2.connect("passbomb", self, "passbomb")
	player3.connect("passbomb", self, "passbomb")
	player4.connect("passbomb", self, "passbomb ")
	player.connect("hitwatermelon", self, "changewatermelonmask")
	player2.connect("hitwatermelon", self, "changewatermelonmask")
	player3.connect("hitwatermelon", self, "changewatermelonmask")
	player4.connect("hitwatermelon", self, "changewatermelonmask")
	count = 0
	gameTimer = $GameTimer
	for child in Globalscript.Players_array:
		if !child:
			match count:
				0:
					player.queue_free()
				1:
					player2.queue_free()
				2:
					player3.queue_free()
				3:
					player4.queue_free()
		count += 1
				

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://MainGame/MainGame.tscn")

func changewatermelonmask(playerid, watermelon):
	for i in range(4, 8):
		if !watermelon.get_child(0).get_collision_mask_bit(i):
			watermelon.get_child(0).set_collision_mask_bit(i, true)
			break
	match playerid:
		"Player":
			watermelon.get_child(0).set_collision_mask_bit(4,false)
		"Player2":
			watermelon.get_child(0).set_collision_mask_bit(5,false)
		"Player3":
			watermelon.get_child(0).set_collision_mask_bit(6,false)
		"Player4":
			watermelon.get_child(0).set_collision_mask_bit(7,false)

func diepermanently(playerid):
	match playerid:
		"Player":
			player.queue_free()
		"Player2":
			player2.queue_free()
		"Player3":
			player3.queue_free()
		"Player4":
			player4.queue_free()

func updateplayerhealth(playerid):
	match playerid:
		"Player":
			player.update_heartsprite()
		"Player2":
			player2.update_heartsprite()
		"Player3":
			player3.update_heartsprite()
		"Player4":
			player4.update_heartsprite()

func updateplayer(playerid):
	print(playerid)
	match playerid:
		"Player":
			player.pickup()
			var Confetti = confetti.instance()
			add_child(Confetti)
			Confetti.global_position = player.global_position
		"Player2":
			player2.pickup()
			var Confetti = confetti.instance()
			add_child(Confetti)
			Confetti.global_position = player2.global_position
		"Player3":
			player3.pickup()
			var Confetti = confetti.instance()
			add_child(Confetti)
			Confetti.global_position = player3.global_position
		"Player4":
			player4.pickup()
			var Confetti = confetti.instance()
			add_child(Confetti)
			Confetti.global_position = player4.global_position

func passbomb(playerid,timercount):
	print(timercount)
	match playerid:
		"Player":
			player.canpass = false
			player.weaponcarriedC.show()
			player.passtimer.start()
			player.timerstatus = timercount
			match timercount:
				1:
					player.bombtimer1.start()
					player.bombblinkTimer.start()
					player.bombblinkTimer.wait_time = 1
				2:
					player.bombtimer2.start()
					player.bombblinkTimer.start()
					player.bombblinkTimer.wait_time = 0.5
				3:
					player.bombtimer3.start()
					player.bombblinkTimer.start()
					player.bombblinkTimer.wait_time = 0.1
		"Player2":
			player2.canpass = false
			player2.weaponcarriedC.show()
			player2.passtimer.start()
			player2.timerstatus = timercount
			match timercount:
				1:
					player2.bombtimer1.start()
					player2.bombblinkTimer.start()
					player2.bombblinkTimer.wait_time = 1
				2:
					player2.bombtimer2.start()
					player2.bombblinkTimer.start()
					player2.bombblinkTimer.wait_time = 0.5
				3:
					player2.bombtimer3.start()
					player2.bombblinkTimer.start()
					player2.bombblinkTimer.wait_time = 0.1
		"Player3":
			player3.canpass = false
			player3.weaponcarriedC.show()
			player3.passtimer.start()
			player3.timerstatus = timercount
			match timercount:
				1:
					player3.bombtimer1.start()
					player3.bombblinkTimer.start()
					player3.bombblinkTimer.wait_time = 1
				2:
					player3.bombtimer2.start()
					player3.bombblinkTimer.start()
					player3.bombblinkTimer.wait_time = 0.5
				3:
					player3.bombtimer3.start()
					player3.bombblinkTimer.start()
					player3.bombblinkTimer.wait_time = 0.1
		"Player4":
			player4.canpass = false
			player4.weaponcarriedC.show()
			player4.passtimer.start()
			player4.timerstatus = timercount
			match timercount:
				1:
					player4.bombtimer1.start()
					player4.bombblinkTimer.start()
					player4.bombblinkTimer.wait_time = 1
				2:
					player4.bombtimer2.start()
					player4.bombblinkTimer.start()
					player4.bombblinkTimer.wait_time = 0.5
				3:
					player4.bombtimer3.start()
					player4.bombblinkTimer.start()
					player4.bombblinkTimer.wait_time = 0.1

func generateBullet(playerid):
	print(playerid)
	match playerid:
		"Player":
			bulletShoot(playerid,player.global_position,player.direction)
		"Player2":
			bulletShoot(playerid,player2.global_position,player2.direction)
		"Player3":
			bulletShoot(playerid,player3.global_position,player3.direction)
		"Player4":
			bulletShoot(playerid,player4.global_position,player4.direction)

func generateExplosion(playerid):
	print("Explosion")
	match playerid:
		"Player":
			explosion(playerid,player.global_position)
		"Player2":
			explosion(playerid,player2.global_position)
		"Player3":
			explosion(playerid,player3.global_position)
		"Player4":
			explosion(playerid,player4.global_position)
			
func bulletShoot(playerid,position,direction):
	var bullet = bulletIns.instance()
	var animationPlayer = bullet.get_child(0)
	var currentscene = get_tree().current_scene
	currentscene.add_child(bullet)
	match playerid:
		"Player":
			bullet.get_child(0).set_collision_mask_bit(4,false)
		"Player2":
			bullet.get_child(0).set_collision_mask_bit(5,false)
		"Player3":
			bullet.get_child(0).set_collision_mask_bit(6,false)
		"Player4":
			bullet.get_child(0).set_collision_mask_bit(7,false)
	bullet.position = position
	bullet.linear_velocity = Vector2(direction * 600, -100)
	
func explosion(playerid,position):
	
	var explosion = explosionIns.instance()
	var currentscene = get_tree().current_scene
	currentscene.add_child(explosion)
	explosion.position = position
	
func _on_GameTimer_timeout():
	print("Time 20s")


func _on_ItemTimer_timeout():
	var Itembox = load("res://Items/ItemBox.tscn")
	var box = Itembox.instance()
	var currentscene = get_tree().current_scene
	currentscene.add_child(box)
	var index = randi() % 4
	var spawnpt = itemspawn.get_children()
	box.position = spawnpt[index].position
	box.connect("playertouch", self, "updateplayer")
