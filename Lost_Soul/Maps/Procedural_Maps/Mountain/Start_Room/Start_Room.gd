extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(_exits : Array):
	$Variants/Opening.get_child(randi()%3).show()

func get_spawn_point(_exit_id : int) -> Vector2:
	return $Entrances.get_child(0).position

func get_start_point() -> Vector2:
	return $Entrances.get_child(1).position
