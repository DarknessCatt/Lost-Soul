extends Node2D

class_name Base_Room

export(Vector2) var camera_limits : Vector2 = Vector2(1024, 600)

export(RoomConstants.room_types) var room_type : int = RoomConstants.room_types.NORMAL
export(Array, Vector2) var room_positions : Array = [Vector2(0,0)]
export(Array, Resource) var exits : Array = []

# warning-ignore:unused_signal
signal player_exited(exit)

func _ready():
	for exit in exits:
		assert(exit.position in room_positions)

func open_exits(_exits : Array):
	pass

func get_spawn_point(_exit_id : int) -> Vector2:
	return Vector2(528, 200)
