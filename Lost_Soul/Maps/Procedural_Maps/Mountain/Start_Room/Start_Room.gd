extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func get_spawn_point(_exit_id : int) -> Vector2:
	return $Entrances.get_child(0).global_position

func get_start_point() -> Vector2:
	return $Entrances.get_child(1).global_position
