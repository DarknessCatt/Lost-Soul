extends Node2D

func _input(event):
		if event.is_action_pressed("pause"):
			$Tween.stop_all()

			if get_tree().paused == true:
				get_tree().paused = false
				$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 0, 0.1)

			else:
				get_tree().paused = true
				$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 1, 0.1)

			$Tween.start()

func _on_Settings_exited():
	get_tree().paused = false
	$Tween.stop_all()
	$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 0, 0.1)
	$Tween.start()
