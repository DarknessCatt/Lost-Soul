extends Node2D

export(bool) var print_analytics : bool = false

var room_list : Array = []

var start_rooms : Array = []
var normal_rooms : Dictionary = {RoomConstants.exit_dir.UP:[], RoomConstants.exit_dir.DOWN:[], RoomConstants.exit_dir.LEFT:[], RoomConstants.exit_dir.RIGHT:[]}
var power_rooms : Array = []
var bonus_rooms : Array = []
var gate_rooms : Array = []

var room_queue : Dictionary = {"list":[], "pointer":0}

func prepare_rooms(path : String):
	#var path = "res://abstracedural/Rooms/"
	var dir : Directory = Directory.new()

	#Pega todos os arquivos .tscn no caminho
	if dir.open(path) == OK:
		# warning-ignore:return_value_discarded
		dir.list_dir_begin(true, true)
		var room_folder = dir.get_next()
		while room_folder != "":

			var room_dir : Directory = Directory.new()
			assert(room_dir.open("%s/%s" % [path, room_folder]) == OK)
			# warning-ignore:return_value_discarded
			room_dir.list_dir_begin(true, true)

			var file_name = room_dir.get_next()

			while file_name != "":
				if ".tscn" in file_name:
					room_list.append(load("%s/%s/%s" % [path, room_folder, file_name]).instance())
					break
				file_name = room_dir.get_next()

			room_dir.list_dir_end()
			room_folder = dir.get_next()

	else:
		print("An error occurred when trying to access the rooms folder.")
		return

	#Organiza os quartos
	for room in room_list:
		match(room.room_type):

			RoomConstants.room_types.NORMAL:
				for exit in room.exits:
					match(exit.direction):

						RoomConstants.exit_dir.UP:
							if not room in normal_rooms[RoomConstants.exit_dir.UP]:
								normal_rooms[RoomConstants.exit_dir.UP].append(room)

						RoomConstants.exit_dir.DOWN:
							if not room in normal_rooms[RoomConstants.exit_dir.DOWN]:
								normal_rooms[RoomConstants.exit_dir.DOWN].append(room)

						RoomConstants.exit_dir.LEFT:
							if not room in normal_rooms[RoomConstants.exit_dir.LEFT]:
								normal_rooms[RoomConstants.exit_dir.LEFT].append(room)

						RoomConstants.exit_dir.RIGHT:
							if not room in normal_rooms[RoomConstants.exit_dir.RIGHT]:
								normal_rooms[RoomConstants.exit_dir.RIGHT].append(room)

			RoomConstants.room_types.START:
				start_rooms.append(room)

			RoomConstants.room_types.POWER:
				power_rooms.append(room)

			RoomConstants.room_types.BONUS:
				bonus_rooms.append(room)

			RoomConstants.room_types.GATE:
				gate_rooms.append(room)

	if print_analytics:
		print("Normal Room Direction Distribution:")
		print("UP: "+str(normal_rooms[RoomConstants.exit_dir.UP].size()))
		print("DOWN: "+str(normal_rooms[RoomConstants.exit_dir.DOWN].size()))
		print("LEFT: "+str(normal_rooms[RoomConstants.exit_dir.LEFT].size()))
		print("RIGHT: "+str(normal_rooms[RoomConstants.exit_dir.RIGHT].size()))

func prepare_room_list(type: int, dir : int = RoomConstants.exit_dir.UP) -> void:
	match(type):

		RoomConstants.room_types.START:
			room_queue.list = start_rooms

		RoomConstants.room_types.NORMAL:
			room_queue.list = normal_rooms[dir]

		RoomConstants.room_types.POWER:
			room_queue.list = power_rooms

		RoomConstants.room_types.BONUS:
			room_queue.list = bonus_rooms

		RoomConstants.room_types.GATE:
			room_queue.list = gate_rooms

	room_queue.list.shuffle()
	room_queue.pointer = 0

func get_room():
	if room_queue.pointer >= room_queue.list.size():
		return null

	var room = room_queue.list[room_queue.pointer].duplicate()
	room_queue.pointer += 1

	return room

func free():
	for room in room_list:
		room.call_deferred("free")

	.free()
