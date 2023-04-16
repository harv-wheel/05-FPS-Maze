extends Area

var keyrot = 0

func _on_key_body_entered(body):
	if body.name == "Player":
		var exit = get_node_or_null("/root/Game/Maze/Exit")
		if exit != null:
			var sound = get_node_or_null("/root/Game/Key")
			if sound != null:
				sound.playing = true
			exit.unlock()
			queue_free()

#func physics_process(_delta):
	#$key.transform.rotation_degrees.y += 1 Trying to get the key to rotate. Not working so whatever
