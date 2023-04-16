extends Spatial


func shoot():
	show()
	$FlashTimer.start()

func _on_FlashTimer_timeout():
	hide()
