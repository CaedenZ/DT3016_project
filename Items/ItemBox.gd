extends Sprite


signal playertouch(playerid)


func _on_Area2D_body_entered(body):
	#print("Collected ", body.name)
	emit_signal("playertouch", body.name)
