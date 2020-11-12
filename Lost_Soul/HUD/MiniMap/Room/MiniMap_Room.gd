extends Node2D

export(Color) var room_color : Color = Color(1, 1, 1)
export(Color) var door_color : Color = Color(0.45, 0.825, 0.9)

var room_size : int = 25

func clear_icons(room_type : String):
	for icon in $Icons.get_children():
		if icon.name != room_type:
			icon.call_deferred("free")

func create_room(room_data : Dictionary) -> void:
	#print("creating room at: " + str(room_data.map_position))
	var room : Base_Room = room_data.node
	# warning-ignore:narrowing_conversion
	var room_percentage : float = 0.85

	match(room.room_type):

		RoomConstants.room_types.GATE:
			clear_icons("Gate")

		RoomConstants.room_types.CHECKPOINT, RoomConstants.room_types.START:
			clear_icons("Checkpoint")

		RoomConstants.room_types.POWER:
			clear_icons("Power")

		RoomConstants.room_types.BONUS:
			clear_icons("Bonus")

		RoomConstants.room_types.NORMAL:
			$Icons.call_deferred("free")

	for room_positon in room.room_positions:
		var room_piece = Polygon2D.new()

		#Basic Room
		room_piece.color = room_color
		room_piece.polygon = \
			PoolVector2Array([Vector2(room_size*(1-room_percentage),room_size*(1-room_percentage)), \
							Vector2(room_size*(1-room_percentage), room_size*room_percentage), \
							Vector2(room_size*room_percentage, room_size*room_percentage), \
							Vector2(room_size*room_percentage, room_size*(1-room_percentage))])
		room_piece.position = room_positon*room_size

		#Spreading Room_Piece Sides
		if room.room_positions.has(room_positon + Vector2.LEFT):
			room_piece.polygon[0].x = 0
			room_piece.polygon[1].x = 0

		if room.room_positions.has(room_positon + Vector2.RIGHT):
			room_piece.polygon[2].x = room_size
			room_piece.polygon[3].x = room_size

		if room.room_positions.has(room_positon + Vector2.UP):
			room_piece.polygon[0].y = 0
			room_piece.polygon[3].y = 0

		if room.room_positions.has(room_positon + Vector2.DOWN):
			room_piece.polygon[1].y = room_size
			room_piece.polygon[2].y = room_size

		self.call_deferred("add_child", room_piece)

	var door_percentage : float = 0.6

	for exit_data in room_data.exits:
		var exit = exit_data.exit
		var door : Polygon2D = Polygon2D.new()

		door.color = door_color
		door.position = exit.position*room_size
		door.polygon = \
			PoolVector2Array([Vector2(room_size*(1-door_percentage),room_size*(1-door_percentage)), \
							Vector2(room_size*(1-door_percentage), room_size*door_percentage), \
							Vector2(room_size*door_percentage, room_size*door_percentage), \
							Vector2(room_size*door_percentage, room_size*(1-door_percentage))])

		match(exit.direction):
			RoomConstants.exit_dir.UP, RoomConstants.exit_dir.DOWN:
				door.position.y += room_size*(1-door_percentage)
				if exit.direction == RoomConstants.exit_dir.UP: door.position.y *= -1

			RoomConstants.exit_dir.LEFT, RoomConstants.exit_dir.RIGHT:
				door.position.x += room_size*(1-door_percentage)
				if exit.direction == RoomConstants.exit_dir.LEFT: door.position.x *= -1

		self.call_deferred("add_child", door)
