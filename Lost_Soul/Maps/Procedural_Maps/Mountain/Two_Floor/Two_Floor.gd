extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	if rand_range(0, 1) < 0.5: $Variants/Middle_Passage/Top.call_deferred("free")
	else: $Variants/Middle_Passage/Bot.call_deferred("free")

	for opening in $Variants/Openings.get_children():
		if rand_range(0, 1) < 0.5:
			opening.call_deferred("free")

	var layouts : Array = $Objects.get_children()
	#layouts.shuffle()

	layouts[1].call_deferred("free")
	layouts[2].call_deferred("free")

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy in $Objects.get_child(0).get_children():
		enemy.respawn()
