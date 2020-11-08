extends Base_Room

signal checkpoint_reached()
signal checkpoint_activated(menu)

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, _rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func get_start_point() -> Vector2:
	return $Objects/Altar.position

func refresh_room():
	$Objects/Altar.reset()


func _on_checkpoint_activated(checkpoint_menu):
	emit_signal("checkpoint_activated", checkpoint_menu)

func _on_checkpoint_reached(_checkpoint):
	pass
