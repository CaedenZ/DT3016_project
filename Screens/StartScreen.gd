extends Node2D


var CharacterSelectionScreen = "res://Screens/CharacterSelectionScreen.tscn"

func _on_Button_pressed():
	print("button pressed")
	get_tree().change_scene(CharacterSelectionScreen)

	
