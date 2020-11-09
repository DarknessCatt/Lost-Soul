extends Node2D

class_name Base_Room

export(Vector2) var camera_limits : Vector2 = Vector2(1024, 600)

export(RoomConstants.room_types) var room_type : int = RoomConstants.room_types.NORMAL
export(Array, Vector2) var room_positions : Array = [Vector2(0,0)]
export(Array, Resource) var exits : Array = []

var exits_verified : bool = false

# warning-ignore:unused_signal
signal player_exited(exit)

func _ready():
	if not exits_verified:
		for exit in exits:
			assert(exit.position in room_positions)
		exits_verified = true

	refresh_room()

func open_exits(_exits : Array, _rank : int):
	pass

func clear_enemy_rank(node : Node2D, room_rank : int) -> void:
	for child in node.get_children():

		if child is Enemy_FSM:
			if not child.allowed_ranks[room_rank]: child.call_deferred("free")

		else: clear_enemy_rank(child, room_rank)

func get_spawn_point(_exit_id : int) -> Vector2:
	return Vector2(528, 200)

#Game_Controller
func refresh_room():
	pass
