extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	var middle_blocks : Array = $Variants/Middle_Passage.get_children()
	middle_blocks.shuffle()

	middle_blocks[0].call_deferred("free")
	for i in range(middle_blocks.size()-1):
		if rand_range(0, 1) < 0.3:
			middle_blocks[i+1].call_deferred("free")

	for opening in $Variants/Openings.get_children():
		if rand_range(0, 1) < 0.5:
			opening.call_deferred("free")

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position
