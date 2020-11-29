extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))
	$Soul.Soul_Value = 100 + rank*50

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position
