extends Node2D

var hero : KinematicBody2D
var camera : Camera2D
var screen_room : Node2D

var map_data : Array

# Tudo isso a seguir ficaria em um Game Manager
enum {READY, FADE_OUT, FADE_IN, REVEAL}
var cur_pos : Vector2
var change_state : int = READY
var spawn_point : Vector2

func _ready():
	hero = $Screen/Viewport/Hero
	camera = hero.get_node("Camera")
	screen_room = $Screen/Viewport/Room

	var generator = Map_Generator.new()

	generator.generate()

	map_data = generator.map_data
	cur_pos = generator.START_POS

	generator.call_deferred("free")

	enter_room(map_data[cur_pos.x][cur_pos.y].node)
	hero.position = map_data[cur_pos.x][cur_pos.y].node.get_start_point()

func enter_room(room : Base_Room):
	screen_room.call_deferred("add_child", room)
	room.call_deferred("connect", "player_exited", self, "_room_exited")

	camera.offset = Vector2.ZERO
	# warning-ignore:narrowing_conversion
	camera.limit_right = room.camera_limits.x
	# warning-ignore:narrowing_conversion
	camera.limit_bottom = room.camera_limits.y

	hero.position = spawn_point

	yield(room, "tree_entered")

func leave_room(next_room : Vector2, entrance : Exit, exit : Exit):
	change_state = FADE_OUT
	#warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)

	var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node
	room.call_deferred("disconnect", "player_exited", self, "_room_exited")
	screen_room.call_deferred("remove_child", room)
	yield(room, "tree_exited")

	cur_pos = next_room
	room = map_data[cur_pos.x][cur_pos.y].node
	spawn_point = room.get_spawn_point(exit.id)

	var norm_player_pos : Vector2 = \
		Vector2(hero.position.x - 1024*entrance.position.x, hero.position.y - 600*entrance.position.y)
	var norm_spawn_pos : Vector2 = \
		Vector2(spawn_point.x - 1024*exit.position.x, spawn_point.y - 600*exit.position.y)

	$Room_Transition/Tween.interpolate_property($Room_Transition/Blackout, "modulate:a", 0, 1, 0.1)
	$Room_Transition/Tween.interpolate_property(camera, "offset", Vector2.ZERO, norm_player_pos-norm_spawn_pos, 0.7)
	$Room_Transition/Tween.start()

func _room_exited(exit_id : int):
	if change_state == READY:
		hero.cutscene = hero.cutscene_type.FULL

		var cur_room = map_data[cur_pos.x][cur_pos.y]

		for exit_data in cur_room.exits:
			if exit_data.exit.id == exit_id:
				leave_room(exit_data.to, exit_data.exit, exit_data.entrance)
				return

func _on_Tween_tween_all_completed():
	if change_state == FADE_OUT:
		change_state = FADE_IN
		$Room_Transition/change_timer.start()
		var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node

		enter_room(room)

		$Room_Transition/Tween.interpolate_property($Room_Transition/Blackout, "modulate:a", 1, 0, 0.1)
		$Room_Transition/Tween.start()

func _on_change_timer_timeout():
	change_state = READY
	hero.cutscene = hero.cutscene_type.NONE
