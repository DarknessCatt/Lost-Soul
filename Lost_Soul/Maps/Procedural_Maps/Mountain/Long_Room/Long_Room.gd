extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	for cloud in $Variants/Clouds.get_children():
		if rand_range(0, 1) < 0.4:
			cloud.call_deferred("free")

	if rand_range(0, 1) < 0.5:
		$Variants/Middle_Cave.call_deferred("free")

	for block in $Blocks.get_children():
		$Objects.get_node(block.name).call_deferred("free")

	for enemy_node in $Objects.get_children():
		enemy_node.get_child(randi()%enemy_node.get_child_count()).call_deferred("free")

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy_node in $Objects.get_children():
		for enemy in enemy_node.get_children():
			enemy.respawn()
