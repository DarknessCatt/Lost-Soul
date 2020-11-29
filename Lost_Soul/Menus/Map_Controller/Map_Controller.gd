extends Node2D

const MAP_SIZE : Vector2 = Vector2(14,14)
const START_POINT : Vector2 = Vector2(7, 7)

var hero : KinematicBody2D
var camera : Camera2D
var screen_room : Node2D

var map_data : Array

export(PackedScene) var initial_tutorial : PackedScene

func _ready():
	hero = $Normal_Game/Screen/Viewport/Hero
	camera = hero.get_node("Camera")
	screen_room = $Normal_Game/Screen/Viewport/Room

	var generator = Map_Generator.new()
	generator.setup(MAP_SIZE, START_POINT)

	var room_list : Array = generator.generate()

	for room in room_list:
		match(room.node.room_type):

			RoomConstants.room_types.POWER:
				room.node.connect("change_tutorial", self, "enter_tutorial")

			RoomConstants.room_types.CHECKPOINT, RoomConstants.room_types.START:
				room.node.connect("checkpoint_activated", self, "enter_levelup")
				room.node.connect("checkpoint_reached", self, "mark_checkpoint")

			RoomConstants.room_types.BOSS:
				room.node.connect("boss_entered", self, "enter_boss")

	map_data = generator.map_data
	cur_pos = START_POINT

	generator.call_deferred("free")

	$Normal_Game/MiniMap.room_size = MAP_SIZE.y
	$Normal_Game/MiniMap.create_map(room_list)

	enter_room(map_data[cur_pos.x][cur_pos.y].node)
	hero.position = map_data[cur_pos.x][cur_pos.y].node.get_start_point()

	#Add Initial Tutorial
	temp_screen = initial_tutorial.instance()
	hero.cutscene = hero.cutscene_type.PHYSICS
	# warning-ignore:return_value_discarded
	temp_screen.connect("tutorial_ended", self, "leave_tutorial")
	self.call_deferred("remove_child", game_screen)
	$Temp_Screen/Viewport.call_deferred("add_child", temp_screen)
	current_scene = scenes.temp_screen

func _input(event):
	if event.is_action_pressed("minimap") and (current_scene == scenes.play or current_scene == scenes.on_boss):
		$Normal_Game/MiniMap.visible = not $Normal_Game/MiniMap.visible

# Hero's Death and Respawn
var respawn_room : Vector2

func mark_checkpoint():
	respawn_room = cur_pos

func _on_Hero_dead():
	# warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)
	hero.die()

	if current_scene == scenes.on_boss:
		screen_room.call_deferred("remove_child", temp_screen)
		screen_room.call_deferred("add_child", map_data[cur_pos.x][cur_pos.y].node)

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 2.3)
	$Scene_Transtition/Tween.start()
	current_scene = scenes.respawning

#Special Room Transitions

#Scene control FSM
enum scenes {play, respawning, temp_screen, to_boss, on_boss}
var current_scene : int = scenes.play

var temp_screen
onready var game_screen : Node2D = $Normal_Game

func enter_tutorial(tutorial : PackedScene):
	temp_screen = tutorial.instance()
	hero.cutscene = hero.cutscene_type.PHYSICS

	# warning-ignore:return_value_discarded
	temp_screen.connect("tutorial_ended", self, "leave_tutorial")

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0.360784, 0.807843, 1, 1), 1.5)
	$Scene_Transtition/Tween.start()

func leave_tutorial() -> void:
	temp_screen.disconnect("tutorial_ended", self, "leave_tutorial")
	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0.360784, 0.807843, 1, 1), 1)
	$Scene_Transtition/Tween.start()
	hero.cutscene = hero.cutscene_type.NONE

func enter_levelup(menu : PackedScene) -> void:
	temp_screen = menu.instance()
	temp_screen.hero = self.hero
	# warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)
	hero.cutscene = hero.cutscene_type.PHYSICS

	# warning-ignore:return_value_discarded
	temp_screen.connect("menu_exited", self, "leave_levelup")

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(1, 0.301961, 0.301961), 1.5)
	$Scene_Transtition/Tween.start()

func leave_levelup() -> void:
	temp_screen.disconnect("menu_exited", self, "leave_levelup")
	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(1, 0.301961, 0.301961), 1)
	$Scene_Transtition/Tween.start()
	hero.cutscene = hero.cutscene_type.NONE
	game_screen.get_node("HUD/Player_Status").update_HUD()

func enter_boss(scene : Node2D) -> void:
	# warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)
	hero.cutscene = hero.cutscene_type.FULL

	temp_screen = scene
	temp_screen.connect("room_exited", self, "leave_boss")

	# warning-ignore:narrowing_conversion
	camera.limit_right = temp_screen.camera_limits.x
	# warning-ignore:narrowing_conversion
	camera.limit_bottom = temp_screen.camera_limits.y

	current_scene = scenes.to_boss

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 0.2)
	$Scene_Transtition/Tween.start()

func leave_boss() -> void:
	# warning-ignore:return_value_discarded
	hero.move_and_slide(Vector2.ZERO)
	hero.cutscene = hero.cutscene_type.FULL

	temp_screen.disconnect("room_exited", self, "leave_boss")

	current_scene = scenes.on_boss

	$Scene_Transtition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 0.2)
	$Scene_Transtition/Tween.start()
 
func _on_Scene_tween_all_completed():
	$Room_Transition/Tween.interpolate_property($Room_Transition/Blackout, \
		"modulate:a", 1, 0, 0.5)
	$Room_Transition/Tween.start()

	match(current_scene):

		scenes.play:
			self.call_deferred("remove_child", game_screen)
			$Temp_Screen/Viewport.call_deferred("add_child", temp_screen)
			current_scene = scenes.temp_screen

		scenes.temp_screen:
			$Temp_Screen/Viewport.call_deferred("remove_child",temp_screen)
			self.call_deferred("add_child", game_screen)
			current_scene = scenes.play

		scenes.respawning:
			var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node
			room.call_deferred("disconnect", "player_exited", self, "_room_exited")
			screen_room.call_deferred("remove_child", room)
			yield(room, "tree_exited")

			room.request_ready()

			cur_pos = respawn_room
			room = map_data[cur_pos.x][cur_pos.y].node
			spawn_point = room.get_start_point()

			enter_room(room)
			hero.cutscene = hero.cutscene_type.NONE

			current_scene = scenes.play

		scenes.to_boss:
			var room : Base_Room =  map_data[cur_pos.x][cur_pos.y].node
			screen_room.call_deferred("remove_child", room)
			screen_room.call_deferred("add_child", temp_screen)

			room.request_ready()

			hero.position = temp_screen.get_spawn_point()
			hero.cutscene = hero.cutscene_type.NONE

			current_scene = scenes.on_boss

		scenes.on_boss:
			var room : Base_Room =  map_data[cur_pos.x][cur_pos.y].node
			screen_room.call_deferred("remove_child", temp_screen)
			screen_room.call_deferred("add_child", room)

			# warning-ignore:narrowing_conversion
			camera.limit_right = room.camera_limits.x
			# warning-ignore:narrowing_conversion
			camera.limit_bottom = room.camera_limits.y

			hero.position = room.get_start_point()
			hero.cutscene = hero.cutscene_type.NONE

			current_scene = scenes.play

# General Room Transitions

enum {READY, FADE_OUT, FADE_IN}
var cur_pos : Vector2
var change_state : int = READY
var spawn_point : Vector2

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

	$Normal_Game/MiniMap.change_room(map_data[cur_pos.x][cur_pos.y].map_position)

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
