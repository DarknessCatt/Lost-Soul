extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array):
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

	var enemies = $Objects.get_children()
	enemies.shuffle()

	for i in range(0,3):
		enemies[i].call_deferred("free")

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy in $Objects.get_children():
		enemy.respawn()
