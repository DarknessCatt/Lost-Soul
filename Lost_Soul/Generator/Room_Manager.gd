class_name Room_Manager

var print_analytics : bool = false

var room_list : Array = []

var normal_rooms : Dictionary = {RoomConstants.exit_dir.UP:[], RoomConstants.exit_dir.DOWN:[], RoomConstants.exit_dir.LEFT:[], RoomConstants.exit_dir.RIGHT:[]}
var special_rooms : Dictionary = {}

var room_queue : Dictionary = {"list":[], "pointer":0}

func prepare_rooms(path : String):

	#Cria um novo array para todo tipo de quarto que não for NORMAL
	for type in RoomConstants.room_types:
		type = RoomConstants.room_types[type]
		if type != RoomConstants.room_types.NORMAL:
			special_rooms[type] = []

	var dir : Directory = Directory.new()

	#Pega todos os arquivos .tscn no caminho
	if dir.open(path) == OK:
		# warning-ignore:return_value_discarded
		dir.list_dir_begin(true, true)
		var room_folder = dir.get_next()
		while room_folder != "":

			var room_dir : Directory = Directory.new()
			assert(room_dir.open("%s%s" % [path, room_folder]) == OK)
			# warning-ignore:return_value_discarded
			room_dir.list_dir_begin(true, true)

			var file_name = room_dir.get_next()

			while file_name != "":
				if ".tscn" in file_name:
					room_list.append(load("%s%s/%s" % [path, room_folder, file_name]).instance())
					break
				file_name = room_dir.get_next()

			room_dir.list_dir_end()
			room_folder = dir.get_next()

	else:
		print("An error occurred when trying to access the rooms folder.")
		return

	#Organiza os quartos
	for room in room_list:
		if room.room_type == RoomConstants.room_types.NORMAL:

			#Organiza um pouco mais, separando por entradas
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

		else:
			special_rooms[room.room_type].append(room)

	if print_analytics:
		print("Normal Room Direction Distribution:")
		print("UP: "+str(normal_rooms[RoomConstants.exit_dir.UP].size()))
		print("DOWN: "+str(normal_rooms[RoomConstants.exit_dir.DOWN].size()))
		print("LEFT: "+str(normal_rooms[RoomConstants.exit_dir.LEFT].size()))
		print("RIGHT: "+str(normal_rooms[RoomConstants.exit_dir.RIGHT].size()))

func prepare_room_list(type: int, dir : int = RoomConstants.exit_dir.UP) -> void:

	if type == RoomConstants.room_types.NORMAL:
		room_queue.list = normal_rooms[dir]

	else:
		room_queue.list = special_rooms[type]

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
