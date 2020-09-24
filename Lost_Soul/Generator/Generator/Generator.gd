extends Node2D

var MAP_SIZE : Vector2 = Vector2(30, 30)
var START_POS : Vector2 = Vector2(15, 15)

var gen_seed : int = 9162325

var map_data : Array

func _ready():
	$Room_Manager.prepare_rooms("res://Maps/Procedural_Maps/Mountain/")
	generate()

#Atualmente gera o mapa
func generate():

	if gen_seed == 0:
		randomize()
		gen_seed = randi()%9999999

	$Seed.text += str(gen_seed)

	print("Seed: "+str(gen_seed))
	seed(gen_seed)

	for x in range(MAP_SIZE.x):
		map_data.append([])
		for _y in range(MAP_SIZE.y):
			map_data[x].append(null)

	var room_pos = START_POS

	#Create Start Room
	var start_room : Dictionary = make_special_room(room_pos, RoomConstants.room_types.START)
	start_room.room["rank"] = 0

	var room_list : Array = [start_room.room]

	#Rank 0 + caminhos
	room_list += make_branch(room_list, 0, 5)
#	room_list += make_branch(room_list, 0, 3, RoomConstants.room_types.BONUS)
#	room_list += make_branch(room_list, 0, 3, RoomConstants.room_types.BONUS)
#	room_list += make_branch(room_list, 0, 3, RoomConstants.room_types.BONUS)

	#Rank 1 + caminhos
#	room_list += make_branch(room_list, 1)
#	room_list += make_branch(room_list, 1, 3, RoomConstants.room_types.BONUS)
#	room_list += make_branch(room_list, 1, 3, RoomConstants.room_types.BONUS)
#	room_list += make_branch(room_list, 1, 3, RoomConstants.room_types.BONUS)

	#Faz alguns ciclos
	make_cycles(room_list)

	#Abre as saidas que forem ser usadas
	for room in room_list: room.node.open_exits(room.exits)

	#Printa o minimapa, bom para debuggar mas da para tirar no futuro.
#	var map : String = ""
#
#	for x in range(MAP_SIZE.x):
#		for y in range(MAP_SIZE.y):
#			if x == START_POS.x and y == START_POS.y:
#				map += "[S]"
#
#			elif map_data[y][x] == null:
#				map += "   "
#
#			else:
#				if map_data[y][x].node.room_type == RoomConstants.room_types.BONUS:
#					map += "[B]"
#
#				elif map_data[y][x].node.room_type == RoomConstants.room_types.POWER:
#					map += "[P]"
#
#				else:
#					map += "["+str(map_data[y][x].rank)+"]"
#
#		map += "\n"
#
#	print(map)

	#Provavelmente mover isso para quem chamar a função para gerar o mapa
	$Room.add_child(map_data[cur_pos.x][cur_pos.y].node)
	map_data[cur_pos.x][cur_pos.y].node.connect("player_exited", self, "_room_exited")
	#Revisar essa posição inicial
	$Player.global_position = map_data[cur_pos.x][cur_pos.y].node.get_start_point()
	$Player/Camera.limit_right = map_data[cur_pos.x][cur_pos.y].node.camera_limits.x
	$Player/Camera.limit_bottom = map_data[cur_pos.x][cur_pos.y].node.camera_limits.y

#Faz os ciclos,
#Com faz eu digo que ele olha as saidas ainda não usadas
#e vê se elas batem com as saidas de outros quartos.
#Pelo menos um dos quartos tem que ser do tipo "Normal".
#Não cria ciclos entre quartos de ranks diferentes.
func make_cycles(room_list : Array) -> void:

	for room in room_list:

		for exit in room.node.exits:
			var leads_to : Vector2 = room.map_position + exit.position
			var entrance_dir : int

			match(exit.direction):

				RoomConstants.exit_dir.UP:
					leads_to += Vector2.UP
					entrance_dir = RoomConstants.exit_dir.DOWN

				RoomConstants.exit_dir.DOWN:
					leads_to += Vector2.DOWN
					entrance_dir = RoomConstants.exit_dir.UP

				RoomConstants.exit_dir.RIGHT:
					leads_to += Vector2.RIGHT
					entrance_dir = RoomConstants.exit_dir.LEFT

				RoomConstants.exit_dir.LEFT:
					leads_to += Vector2.LEFT
					entrance_dir = RoomConstants.exit_dir.RIGHT

			if 	leads_to.x < 0 or leads_to.x >= MAP_SIZE.x or \
				leads_to.y < 0 or leads_to.y >= MAP_SIZE.y or \
				map_data[leads_to.x][leads_to.y] == null:
					continue

			var other_room = map_data[leads_to.x][leads_to.y]

			for entrance in other_room.node.exits:
				if 	entrance.direction == entrance_dir and \
					leads_to.x == (other_room.map_position.x + entrance.position.x) and \
					leads_to.y == (other_room.map_position.y + entrance.position.y):

						if  (room.rank == other_room.rank) and \
							(room.node.room_type == RoomConstants.room_types.NORMAL or \
							other_room.node.room_type == RoomConstants.room_types.NORMAL) and \
							rand_range(0, 1) < 0.5:
							room.exits.append({"exit": exit, "to": leads_to, "entrance": entrance})
							other_room.exits.append({"exit": entrance, "to": (room.map_position + exit.position), "entrance": exit})

						room.node.exits.erase(exit)
						other_room.node.exits.erase(entrance)
						break

#Faz um novo caminho, pegando um quarto aleatorio e tentando partir dele.
#Repete o processo até conseguir criar um caminho do tamanho ideal ou ter
#passado por todos os quartos.
#branch_rank é o rank do caminho, size o tamanho e final_room decide se o ultimo
#quarto é de poder ou bônus.
func make_branch(room_list : Array, branch_rank : int = 0, size : int = 3, final_room_type : int = RoomConstants.room_types.POWER):
	var room_list_pointer : int = room_list.size()
	var branch_data = {}

	room_list.shuffle()

	while room_list_pointer > 0:

		room_list_pointer -= 1

		var branch = []
		var branch_room = room_list[room_list_pointer]

		if branch_room.node.room_type != RoomConstants.room_types.POWER:

			branch_data = choose_exit(branch_room, branch_room.map_position)

			if not branch_data.empty():

				var exit = {"exit": branch_data.exit, "to": branch_data.to}

				branch_data["pos"] = branch_room.map_position
				branch_data["exit"] = exit

				if branch_room.rank >= branch_rank:
					branch_rank = branch_room.rank

				else:
					var gate_room : Dictionary = make_special_room(branch_data.to, RoomConstants.room_types.GATE, {"pos": branch_data.pos, "exit_data":branch_data.exit, "RoomConstants.exit_dir":branch_data.dir})

					if gate_room.empty():
						continue

					gate_room.room["rank"] = branch_rank

					branch_data = gate_room.exit
					branch = [gate_room.room]

				branch += make_path(branch_data, branch_rank, size, final_room_type)

				if branch.size() >= size+1:
					branch_room["exits"].append(exit)
					return branch

				else:
					while not branch.empty(): remove_room(branch.pop_back())

	print("Room List is Empty in Branch!")
	return []

#Cria um novo caminho, colocando um quarto (que tenha saidas) atrás do outro,
#partindo de uma saida do quarto anterior.
# start_data: dicionario com:
#	pos = position of the original room
#	exit = exit from original room (Dictionary)
#	to = position of the new room
#	dir = direction it comes from
# path_limit: o tamanho maximo do caminho,
# 	mas teoricamente ele pode gerar caminhos menores, mas é bloqueado pelo make_branch.
# final_room_type: se o quarto final vai ser de poder ou bônus.
func make_path(start_data : Dictionary, path_rank : int = 0, path_limit : int = 4, final_room_type : int = RoomConstants.room_types.POWER) -> Array:

	var rooms_list : Array = []

	var previous_room : Dictionary = {"pos": start_data.pos, "exit_data": start_data.exit, "exit_dir": start_data.dir}
	var room_pos : Vector2 = start_data.to

	#Create Normal Rooms
	$Room_Manager.prepare_room_list(RoomConstants.room_types.NORMAL, previous_room.exit_dir)

	while rooms_list.size() < path_limit:
		#print("Attempting room in "+str(room_pos))
		var new_room : Dictionary = {}
		new_room["node"] = $Room_Manager.get_room()

		if new_room.node == null:
			#print("\tRoom List Empty!")
			break

		var fits : bool = false
		var return_exit_info : Dictionary
		var room_placement_pos : Vector2

		new_room.node.exits.shuffle()
		#Check/get new room's entrance
		for entrance in new_room.node.exits:
			if entrance.direction == previous_room.exit_dir:

				#Posição "real" do quarto depois que a entrada está alinhada
				room_placement_pos = room_pos - entrance.position
				fits = true

				for pos in new_room.node.room_positions:
					var map_pos : Vector2 = room_placement_pos + pos
					if map_pos.x < 0 or map_pos.x >= MAP_SIZE.x or \
					   map_pos.y < 0 or map_pos.y >= MAP_SIZE.y or \
					   map_data[map_pos.x][map_pos.y] != null:
						#print("\tDoesn't fit because of "+str(map_pos))
						fits = false
						break

				if fits:
					return_exit_info = {"exit": entrance, "to": previous_room.pos, "entrance": previous_room.exit_data.exit}
					new_room.node.exits.erase(entrance)
					break

		if not fits:
			new_room.node.call_deferred("free")
			continue

		var exit_data = self.choose_exit(new_room, room_placement_pos)

		if exit_data.empty():
			#print("\tNo Available Exits!")
			continue

		var next_exit : Dictionary = {"exit": exit_data.exit, "to": exit_data.to}

		#Atualiza a saida do quarto anterior
		previous_room.exit_data["entrance"] = return_exit_info.exit
		map_data[previous_room.pos.x][previous_room.pos.y].node.exits.erase(previous_room.exit_data.exit)

		#Atualiza dados do novo quarto
		new_room["exits"] = [next_exit, return_exit_info]
		new_room["map_position"] = room_placement_pos
		new_room["rank"] = path_rank
		rooms_list.append(new_room)
		self.place_room(new_room)

		#Prepara a data para a próxima iteração
		previous_room.exit_data = next_exit
		previous_room.exit_dir = exit_data.dir
		previous_room.pos = room_pos

		room_pos = exit_data.to

		$Room_Manager.prepare_room_list(RoomConstants.room_types.NORMAL, previous_room.exit_dir)

	#Adding Final Room
	var final_room = make_special_room(room_pos, final_room_type, previous_room)
	final_room.room["rank"] = path_rank
	rooms_list.append(final_room.room)

	return rooms_list

#Coloca um quarto especial.
#From: dicionario com
#	pos: posição do quarto do qual ele vai sair
#	exit_data: dicionario com as informações da saida do quarto anterior
#	RoomConstants.exit_dir: direção da entrada
func make_special_room(position : Vector2, type : int, from : Dictionary = {}) -> Dictionary:
	var new_room_data : Dictionary = {"room":{}, "exit":{}}

	$Room_Manager.prepare_room_list(type)

	match(type):

		RoomConstants.room_types.START:
			new_room_data.room["node"] = $Room_Manager.get_room()
			new_room_data.room["map_position"] = position
			new_room_data.room["exits"] = []

			place_room(new_room_data.room)

		RoomConstants.room_types.POWER, RoomConstants.room_types.BONUS:
			while true:
				new_room_data.room["node"] = $Room_Manager.get_room()

				if new_room_data.room.node == null:
					new_room_data = {}
					break

				var fits = false

				for entrance in new_room_data.room.node.exits:
					if entrance.direction == from.exit_dir:

						var room_placement_pos = position - entrance.position
						fits = true

						for pos in new_room_data.room.node.room_positions:
							var map_pos : Vector2 = room_placement_pos + pos
							if map_pos.x < 0 or map_pos.x >= MAP_SIZE.x or \
							   map_pos.y < 0 or map_pos.y >= MAP_SIZE.y or \
							   map_data[map_pos.x][map_pos.y] != null:
								#print("\tDoesn't fit because of "+str(map_pos))
								fits = false
								break

						if fits:
							from.exit_data["entrance"] = entrance
							map_data[from.pos.x][from.pos.y].node.exits.erase(from.exit_data)
							new_room_data.room["map_position"] = room_placement_pos
							new_room_data.room["exits"] = [{"exit": entrance, "to": from.pos, "entrance": from.exit_data.exit}]
							new_room_data.room.node.exits.erase(entrance)
							break

				if not fits:
					new_room_data.room.node.call_deferred("free")
					continue

				place_room(new_room_data.room)
				break

		RoomConstants.room_types.GATE:
			while true:
				new_room_data.room["node"] = $Room_Manager.get_room()

				if new_room_data.room["node"] == null:
					#print("Gate Queue Empty!")
					new_room_data = {}
					break

				var fits = false
				var room_placement_pos : Vector2
				var return_exit : Dictionary

				new_room_data.room.node.exits.shuffle()

				for entrance in new_room_data.room.node.exits:
					if entrance.direction == from.RoomConstants.exit_dir:

						room_placement_pos = position - entrance.position
						fits = true

						for pos in new_room_data.room.node.room_positions:
							var map_pos : Vector2 = room_placement_pos + pos
							if map_pos.x < 0 or map_pos.x >= MAP_SIZE.x or \
							   map_pos.y < 0 or map_pos.y >= MAP_SIZE.y or \
							   map_data[map_pos.x][map_pos.y] != null:
								#print("\tDoesn't fit because of "+str(map_pos))
								fits = false
								break

						if fits:
							new_room_data.room.node.erase_exit(entrance)
							return_exit = {"exit": entrance, "to": from.pos, "entrance": from.exit_data.exit}
							break

				if not fits:
					new_room_data.room.node.call_deferred("free")
					continue

				var exit_data = choose_exit(new_room_data.room, room_placement_pos)

				if exit_data.empty():
					continue

				var exit = {"exit":exit_data.exit, "to": exit_data.to}

				from.exit_data["entrance"] = return_exit.exit
				map_data[from.pos.x][from.pos.y].node.exits.erase(from.exit_data)

				new_room_data.room["map_position"] = room_placement_pos
				new_room_data.room["exits"] = [return_exit, exit]

				new_room_data.exit["dir"] = exit_data.dir
				new_room_data.exit["to"] = exit_data.to
				new_room_data.exit["pos"] = room_placement_pos
				new_room_data.exit["exit"] = exit

				place_room(new_room_data.room)
				break

	return new_room_data

func choose_exit(new_room : Dictionary, room_placement_pos : Vector2) -> Dictionary:
	var exit_data : Dictionary = {}

	for exit in new_room.node.exits:
		#print("\tgetting exit from "+str(room_placement_pos+exit.position)+" in direction "+str(exit[1]))
		var valid : bool = true
		var dir : int = -1
		var to : Vector2 = Vector2.ZERO
		var room_pos = room_placement_pos + exit.position

		match(exit.direction):

			RoomConstants.exit_dir.UP:
				if (room_pos.y - 1) < 0 or map_data[room_pos.x][room_pos.y-1] != null:
					valid = false
					continue

				dir = RoomConstants.exit_dir.DOWN
				to = Vector2.UP

			RoomConstants.exit_dir.DOWN:
				if (room_pos.y + 1) >= MAP_SIZE.y or map_data[room_pos.x][room_pos.y+1] != null:
					valid = false
					continue

				dir = RoomConstants.exit_dir.UP
				to = Vector2.DOWN

			RoomConstants.exit_dir.LEFT:
				if (room_pos.x - 1) < 0 or map_data[room_pos.x-1][room_pos.y] != null:
					valid = false
					continue

				dir = RoomConstants.exit_dir.RIGHT
				to = Vector2.LEFT

			RoomConstants.exit_dir.RIGHT:
				if (room_pos.x + 1) >= MAP_SIZE.y or map_data[room_pos.x+1][room_pos.y] != null:
					valid = false
					continue

				dir = RoomConstants.exit_dir.LEFT
				to = Vector2.RIGHT

		if valid:
			exit_data["dir"] = dir
			exit_data["to"] = (room_placement_pos + exit.position + to)
			exit_data["exit"] = exit
			break

	return exit_data

func place_room(room_data : Dictionary) -> void:
	var new_room = room_data.node
	var room_placement_pos = room_data.map_position
	#print("\tmarking rooms in map_data")
	for pos in new_room.room_positions:
		var map_pos : Vector2 = room_placement_pos + pos
		map_data[map_pos.x][map_pos.y] = room_data
		#print("\t\t"+str(map_pos))

func remove_room(room_data : Dictionary) -> void:
	var old_room = room_data.node
	var room_placement_pos = room_data.map_position
	#print("\tmarking rooms in map_data")
	for pos in old_room.room_positions:
		var map_pos : Vector2 = room_placement_pos + pos
		map_data[map_pos.x][map_pos.y] = null
		#print("\t\t"+str(map_pos))

	old_room.call_deferred("free")

# Tudo isso ficaria em um Game Manager
enum {READY, FADE_OUT, FADE_IN, REVEAL}
var cur_pos : Vector2 = START_POS
var change_state : int = READY
var spawn_point : Vector2

func _room_exited(exit_id : int):
	if change_state == READY:
		$Player.on_cutscene = true

		var cur_room = map_data[cur_pos.x][cur_pos.y]

		for exit_data in cur_room.exits:
			if exit_data.exit.id == exit_id:
				change_room(exit_data.to, exit_data.exit, exit_data.entrance)
				return

		$Player.on_cutscene = false

func change_room(next_room : Vector2, entrance : Exit, exit : Exit):
	change_state = FADE_OUT
	$Player.move_and_slide(Vector2.ZERO)

	var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node
	room.call_deferred("disconnect", "player_exited", self, "_room_exited")
	$Room.call_deferred("remove_child", room)
	yield(room, "tree_exited")

	cur_pos = next_room
	room = map_data[cur_pos.x][cur_pos.y].node
	spawn_point = room.get_spawn_point(exit.id)

	var norm_player_pos : Vector2 = \
		Vector2($Player.position.x - 1024*entrance.position.x, $Player.position.y - 600*entrance.position.y)
	var norm_spawn_pos : Vector2 = \
		Vector2(spawn_point.x - 1024*exit.position.x, spawn_point.y - 600*exit.position.y)

	$Tween.interpolate_property($Player/Blackout, "modulate:a", 0, 1, 0.1)
	$Tween.interpolate_property($Player/Camera, "offset", Vector2.ZERO, norm_player_pos-norm_spawn_pos, 0.7)
	$Tween.start()

func _on_Tween_tween_all_completed():
	if change_state == FADE_OUT:
		change_state = FADE_IN
		$change_timer.start()
		var room : Base_Room = map_data[cur_pos.x][cur_pos.y].node

		$Player/Camera.offset = Vector2.ZERO
		$Player/Camera.limit_right = room.camera_limits.x
		$Player/Camera.limit_bottom = room.camera_limits.y

		$Player.position = spawn_point

		$Room.call_deferred("add_child", room)
		room.call_deferred("connect", "player_exited", self, "_room_exited")
		yield(room, "tree_entered")

		$Tween.interpolate_property($Player/Blackout, "modulate:a", 1, 0, 0.1)
		$Tween.start()

func _on_change_timer_timeout():
	change_state = READY
	$Player.on_cutscene = false
