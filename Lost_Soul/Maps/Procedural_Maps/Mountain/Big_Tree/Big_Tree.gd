extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	for cloud in $Variants/Clouds.get_children():
		if rand_range(0, 1) <= 0.33:
			cloud.call_deferred("free")

	if rand_range(0, 1) <= 0.5:
		$Variants/Branch.call_deferred("free")

	if rand_range(0, 1) <= 0.5:
		$Variants/Hill.call_deferred("free")

	if rand_range(0, 1) <= 0.5:
		$Variants/CaveIn.call_deferred("free")

	var enemy_layouts : Array = $Objects.get_children()
	enemy_layouts.shuffle()

	enemy_layouts[0].call_deferred("free")
	enemy_layouts[1].call_deferred("free")

	self.clear_enemy_rank($Objects, rank)

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy in $Objects.get_child(0).get_children():
		enemy.respawn()
