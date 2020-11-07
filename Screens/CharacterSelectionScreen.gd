extends Node2D

onready var player1_button = $CanvasLayer/VBoxContainer/Player1/Button1
onready var player2_button = $CanvasLayer/VBoxContainer/Player2/Button2
onready var player3_button = $CanvasLayer/VBoxContainer/Player3/Button3
onready var player4_button = $CanvasLayer/VBoxContainer/Player4/Button4


var MainGameScreen = "res://MainGame/MainGame.tscn"


onready var Players_status = [player1_button, player2_button, player3_button, player4_button]
func _on_Button_pressed():
	var i = 0
	for child in Players_status:
		if child.pressed:
			Globalscript.Players_array[i] = true
			child.modulate.a = 1
		i += 1
	
	print(Globalscript.Players_array)
	get_tree().change_scene(MainGameScreen)
	

	

	


func _on_Button1_toggled(button_pressed):
	if player1_button.pressed:
		player1_button.modulate.a = 1
	else:
		player1_button.modulate.a = 0.5


func _on_Button2_toggled(button_pressed):
	if player2_button.pressed:
		player2_button.modulate.a = 1
	else:
		player2_button.modulate.a = 0.5


func _on_Button3_toggled(button_pressed):
	if player3_button.pressed:
		player3_button.modulate.a = 1
	else:
		player3_button.modulate.a = 0.5


func _on_Button4_toggled(button_pressed):
	if player4_button.pressed:
		player4_button.modulate.a = 1
	else:
		player4_button.modulate.a = 0.5
