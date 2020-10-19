extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

	match(randi()%4):
		0:
			for opening in $Variants/Opening.get_children():
				opening.call_deferred("free")

		1:
			$Variants/Opening/Middle_Opening.call_deferred("free")
			$Variants/Opening/Right_Opening.call_deferred("free")

		2:
			$Variants/Opening/Left_Opening.call_deferred("free")
			$Variants/Opening/Right_Opening.call_deferred("free")

		3:
			$Variants/Opening/Middle_Opening.call_deferred("free")
			$Variants/Opening/Left_Opening.call_deferred("free")

	if(randi()%2 == 0): $Variants/Extended_Plataform.call_deferred("free")

	if(randi()%3 != 0): $Variants/Hill.call_deferred("free")

	var enemies = $Objects.get_children()
	enemies.shuffle()

	for i in range(0,2):
		enemies[i].call_deferred("free")

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

func refresh_room():
	for enemy in $Objects.get_children():
		enemy.respawn()
