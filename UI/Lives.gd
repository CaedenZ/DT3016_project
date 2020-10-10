extends Node2D

onready var heartsprite = $Sprite
onready var lifecounter = $RichTextLabel
var max_hp = 4
var lives = 3
signal diedpermanently(playerid)
func update_heartsprite():
	if lives > 0:
		heartsprite.frame += 1
		max_hp -= 1
		if max_hp <= 0:
			lives -= 1
			update_lifecounter()

func update_lifecounter():
	lifecounter.bbcode_text = "X" + str(lives)
	if lives > 0:
		heartsprite.frame = 0
		max_hp = 4
	else:
		emit_signal("diedpermanently", name)
