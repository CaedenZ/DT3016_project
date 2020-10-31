extends Node2D


var instructionscene = "res://MainGame/MainGame.tscn"

func _on_Button_pressed():
	print("button pressed")
	get_tree().change_scene(instructionscene)

	
