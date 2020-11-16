extends Base_Room

func _on_exit_entered(_body, id):
	self.emit_signal("player_exited", id)

func open_exits(exits : Array, _rank : int):
	$Blocks.show()
	for exit_data in exits: $Blocks.remove_child($Blocks.get_node(str(exit_data.exit.id)))

func get_spawn_point(exit_id : int) -> Vector2:
	return $Entrances.get_child(exit_id).position

export(PackedScene) var Boss_Scene : PackedScene

signal boss_entered(boss_scene)
var on_door : bool = false

func _on_Boss_Door_entered(_body):
	on_door = true
	$Objects/Tween.stop_all()
	$Objects/Tween.interpolate_property($Objects/Arrow, "modulate:a", $Objects/Arrow.modulate.a, 1, 0.3)
	$Objects/Tween.start()

func _on_Boss_Door_exited(_body):
	on_door = false
	$Objects/Tween.stop_all()
	$Objects/Tween.interpolate_property($Objects/Arrow, "modulate:a", $Objects/Arrow.modulate.a, 0, 0.3)
	$Objects/Tween.start()

func _input(event):
	if on_door and event.is_action_pressed("hero_up"):
		assert(Boss_Scene != null, "Boss Scene empty!")
		emit_signal("boss_entered", Boss_Scene)
