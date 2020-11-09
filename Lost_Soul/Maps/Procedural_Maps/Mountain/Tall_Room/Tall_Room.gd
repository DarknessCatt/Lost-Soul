extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	for open in $Variants/Openings.get_children():
		if rand_range(0, 1) < 0.5:
			open.call_deferred("free")

	if rand_range(0, 1) < 0.5:	$Variants/Top_Block/Left.call_deferred("free")
	else:						$Variants/Top_Block/Right.call_deferred("free")

	for block in $Blocks.get_children():
		$Objects/Blocked.get_node(block.name).call_deferred("free")

	for enemy_node in $Objects/Blocked.get_children():
		enemy_node.get_child(randi()%enemy_node.get_child_count()).call_deferred("free")

	$Objects/Middle.get_child(randi()%$Objects/Middle.get_child_count()).call_deferred("free")

	clear_enemy_rank($Objects, rank)

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy_layout in $Objects/Blocked.get_children():
		for enemy in enemy_layout.get_child(0).get_children():
			enemy.respawn()

	for enemy in $Objects/Middle.get_child(0).get_children():
		enemy.respawn()
