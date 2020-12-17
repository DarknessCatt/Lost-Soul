extends Node2D

func _input(event):
		if event.is_action_pressed("pause"):
			$Tween.remove_all()
			MusicHandler.toggle_pause()

			if get_tree().paused == true:
				get_tree().paused = false
				$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 0, 0.1)

			else:
				get_tree().paused = true
				$Menu.show()
				$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 1, 0.1)

			$Tween.start()

			if not get_tree().paused:
				yield($Tween, "tween_all_completed")
				$Menu.hide()

func _on_Settings_exited():
	get_tree().paused = false
	$Tween.remove_all()
	$Tween.interpolate_property($Menu, "modulate:a", $Menu.modulate.a, 0, 0.1)
	$Tween.start()
