extends StaticBody2D

var Player = null

func _on_player_on_top(body):
	Player = body
	if Input.is_action_pressed("hero_down"):
		$Drop_Timer.start()

func _on_player_exited(_body):
	Player = null
	$Drop_Timer.stop()

func _input(event):
	if Player != null:
		if event.is_action_pressed("hero_down"):
			$Drop_Timer.start()

		elif event.is_action_released("hero_down"):
			$Drop_Timer.stop()

func _on_Drop_timeout():
	Player.position. y += 1
