extends Node2D

onready var player1_button = $CanvasLayer/VBoxContainer/Player1/Button
onready var player2_button = $CanvasLayer/VBoxContainer/Player2/Button
onready var player3_button = $CanvasLayer/VBoxContainer/Player3/Button
onready var player4_button = $CanvasLayer/VBoxContainer/Player4/Button


var MainGameScreen = "res://MainGame/MainGame.tscn"


onready var Players_status = [player1_button, player2_button, player3_button, player4_button]
func _on_Button_pressed():
	var i = 0
	for child in Players_status:
		if child.pressed:
			Globalscript.Players_array[i] = true
		i += 1
	
	print(Globalscript.Players_array)
	get_tree().change_scene(MainGameScreen)
	

	
