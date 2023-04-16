extends KinematicBody

var Player = null
var health = 4
var locking = false

onready var scanner = $Scanner

func _process(_delta):
	if Player == null:
		Player = get_node_or_null("/root/Game/Player")
	if Player != null:
		look_at(Player.global_transform.origin, Vector3.UP)
	if scanner.is_colliding():
		var target = scanner.get_collider()
		if target.is_in_group("Player") and locking == false:
			locking = true
			$EnemyAlert.play()
			$LockOn.start()
			#print(locking)
		if not target.is_in_group("Player") and locking == true:
			locking = false
			$EnemyLoseAlert.play()
			$LockOn.stop()
			#print(locking)
	
func damage(d):
	health -= d
	$EnemyHit.play()
	if health <= 0:
		$EnemyDeath.play()
		$Scanner.enabled = false
		$Mesh.hide()
		$CollisionShape.disabled = true
		$EnemyAmbient.stop()
		$EnemyAlert.stop()
		$Dying.start()


func _on_LockOn_timeout():
	var target = scanner.get_collider()
	if target.is_in_group("Player") and $Scanner.enabled == true:
		#print("death")
		var _scene = get_tree().change_scene("res://UI/Lose.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	locking = false


func _on_Dying_timeout():
	queue_free()
