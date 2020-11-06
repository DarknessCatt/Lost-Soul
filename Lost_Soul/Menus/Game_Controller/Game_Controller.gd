extends Node2D

var hero : KinematicBody2D
var camera : Camera2D
var screen_room : Node2D

var map_data : Array

# Room Control
enum {READY, FADE_OUT, FADE_IN}
var cur_pos : Vector2
var change_state : int = READY
var spawn_point : Vector2

func _ready():
	hero = $Normal_Game/Screen/Viewport/Hero
	camera = hero.get_node("Camera")
	screen_room = $Normal_Game/Screen/Viewport/Room

	var generator = Map_Generator.new()

	for room in generator.generate():
		match(room.node.room_type):

			RoomConstants.room_types.POWER:
				room.node.connect("change_tutorial", self, "enter_tutorial")

	map_data = generator.map_data
	cur_pos = generator.START_POS

	generator.call_deferred("free")

	enter_room(map_data[cur_pos.x][cur_pos.y].node)
	hero.position = map_data[cur_pos.x][cur_pos.y].node.get_start_point()

#Special Room Transitions

#Scene control FSM
enum scenes {play, tutorial, menu}
var current_scene : int = scenes.play

var temp_screen : Node2D
var game_screen : Node2D

func enter_tutorial(tutorial : PackedScene):
	game_screen = $Normal_Game
	temp_screen = tutorial.instance()
	hero.cutscene = hero.cutscene_type.PHYSICS

	# warning-ignore:return_value_discarded
	temp_screen.connect("tutorial_ended", self, "return_game")

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0.360784, 0.807843, 1, 1), 1.5)
	$Scene_Transtition/Tween.start()

func return_game() -> void:
	temp_screen.disconnect("tutorial_ended", self, "return_game")
	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0.360784, 0.807843, 1, 1), 1)
	$Scene_Transtition/Tween.start()
	hero.cutscene = hero.cutscene_type.NONE

func _on_Scene_tween_all_completed():
	$Room_Transition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate:a", 1, 0, 1)
	$Room_Transition/Tween.start()

	if current_scene == scenes.play:
		self.call_deferred("remove_child", game_screen)
		$Temp_Screen/Viewport.call_deferred("add_child", temp_screen)
		current_scene = scenes.tutorial

	else:
		$Temp_Screen/Viewport.call_deferred("remove_child",temp_screen)
		self.call_deferred("add_child", game_screen)
		current_scene = scenes.play
		

# General Room Transitions
func enter_room(room : Base_Room):
	screen_room.call_deferred("add_child", room)
	room.call_deferred("connect", "player_exited", self, "_room_exited")

	camera.offset = Vector2.ZERO
	# warning-ignore:narrowing_conversion
	camera.limit_right = room.camera_limits.x
	# warning-ignore:narrowing_conversion
	camera.limit_bottom = room.camera_limits.y

	hero.position = spawn_point

	yield(room, "ready")

func leave_room(next_room : Vector2, entrance : Exit, exit : Exit):
	change_state = FADE_OUT
	#warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)

	var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node
	room.call_deferred("disconnect", "player_exited", self, "_room_exited")
	screen_room.call_deferred("remove_child", room)
	yield(room, "tree_exited")

	room.request_ready()

	cur_pos = next_room
	room = map_data[cur_pos.x][cur_pos.y].node
	spawn_point = room.get_spawn_point(exit.id)

	var norm_player_pos : Vector2 = \
		Vector2(hero.position.x - 1024*entrance.position.x, hero.position.y - 600*entrance.position.y)
	var norm_spawn_pos : Vector2 = \
		Vector2(spawn_point.x - 1024*exit.position.x, spawn_point.y - 600*exit.position.y)

	$Room_Transition/Tween.interpolate_property(screen_room, "modulate:a", 1, 0, 0.1)
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

		$Room_Transition/Tween.interpolate_property(screen_room, "modulate:a", 0, 1, 0.1)
		$Room_Transition/Tween.start()

func _on_change_timer_timeout():
	change_state = READY
	hero.cutscene = hero.cutscene_type.NONE
