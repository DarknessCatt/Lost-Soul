extends Panel

export(PackedScene) var minimap_room : PackedScene
var room_size : int = -1 setget change_size

func change_size(map_size : int) -> void:
	room_size = floor(600/(map_size+4))

func create_map(map_data : Array) -> void:
	assert(room_size > 0)
	for room in map_data:
		if room != null:
			var new_mmr = minimap_room.instance()
			new_mmr.name = str(room.map_position)
			new_mmr.room_size = self.room_size
			new_mmr.create_room(room)
			new_mmr.position = room.map_position*room_size
			$Map.call_deferred("add_child", new_mmr)
