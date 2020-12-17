extends Base_Room

const left_exits = [0, 1, 2]
const right_exits = [3, 4, 5]

func erase_exit(exit):
	var exits_to_erase_id : Array = right_exits
	var exits_to_erase_ar : Array = []

	if exit.id in left_exits: exits_to_erase_id = left_exits

	for ex in self.exits:
		if ex.id in exits_to_erase_id:
			exits_to_erase_ar.append(ex)

	for ex in exits_to_erase_ar:
		self.exits.erase(ex)

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, _rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

#func refresh_room():
#	for enemy in $Objects.get_children():
#		enemy.respawn()
