extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func _on_Area2D_area_entered(area):
	print(area)
	pass # Replace with function body.


func _on_LifeTimer_timeout():
	queue_free()
	pass # Replace with function body.
