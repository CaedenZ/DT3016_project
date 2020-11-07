extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	if global_position.x>1000:
		global_position.x=0
	if global_position.x<0:
		global_position.x=1000
	if global_position.y>600:
		global_position.y=0

func _on_Area2D_area_entered(area):
	print(area)
	pass # Replace with function body.


func _on_LifeTimer_timeout():
	queue_free()
	pass # Replace with function body.
