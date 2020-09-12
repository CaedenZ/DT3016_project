extends Node2D

var count
var gameTimer

func _ready():
	count = 0
	gameTimer = $GameTimer


func _on_GameTimer_timeout():
	print("Time 20s")
	pass # Replace with function body.
