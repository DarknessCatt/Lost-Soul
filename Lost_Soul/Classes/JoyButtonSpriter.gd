class_name JoyButtonSpriter

const joysprite_folder = "res://Assets/controller/"

static func get_arrow(id : int) -> Texture:
	var tex : Texture

	match(id):
		16777231:
			tex = load(joysprite_folder+"arrow_left.png")
		16777232:
			tex = load(joysprite_folder+"arrow_up.png")
		16777233:
			tex = load(joysprite_folder+"arrow_right.png")
		16777234:
			tex = load(joysprite_folder+"arrow_down.png")

	assert(tex != null)
	return tex

static func get_motion_id(event : InputEventJoypadMotion) -> int:
	var id : int
	match(event.axis):
		0:
			if event.axis_value < 0: id = 16
			else: id = 17
		1:
			if event.axis_value < 0: id = 18
			else: id = 19
		2:
			if event.axis_value < 0: id = 20
			else: id = 21
		3:
			if event.axis_value < 0: id = 22
			else: id = 23
		6:
			id = 6
		7:
			id = 7

	return id

static func get_sprite(button : int) -> Texture:
	var tex : Texture

	match(button):
		0:
			tex = load(joysprite_folder+"controller_button_A.png")
		1:
			tex = load(joysprite_folder+"controller_button_B.png")
		2:
			tex = load(joysprite_folder+"controller_button_X.png")
		3:
			tex = load(joysprite_folder+"controller_button_Y.png")
		4:
			tex = load(joysprite_folder+"controller_LB.png")
		5:
			tex = load(joysprite_folder+"controller_RB.png")
		6:
			tex = load(joysprite_folder+"controller_LT.png")
		7:
			tex = load(joysprite_folder+"controller_RT.png")
		10:
			tex = load(joysprite_folder+"controller_view.png")#select
		11:
			tex = load(joysprite_folder+"controller_menu.png")#start
		12:
			tex = load(joysprite_folder+"controller_digi_up.png")
		13:
			tex = load(joysprite_folder+"controller_digi_down.png")
		14:
			tex = load(joysprite_folder+"controller_digi_left.png")
		15:
			tex = load(joysprite_folder+"controller_digi_right.png")

		#Bonus IDs for Joypad Motion
		16:
			tex = load(joysprite_folder+"controller_left_stick_left.png")
		17:
			tex = load(joysprite_folder+"controller_left_stick_right.png")
		18:
			tex = load(joysprite_folder+"controller_left_stick_up.png")
		19:
			tex = load(joysprite_folder+"controller_left_stick_down.png")
		20:
			tex = load(joysprite_folder+"controller_right_stick_left.png")
		21:
			tex = load(joysprite_folder+"controller_right_stick_right.png")
		22:
			tex = load(joysprite_folder+"controller_right_stick_up.png")
		23:
			tex = load(joysprite_folder+"controller_right_stick_down.png")

		#Should never appear
		_:
			tex = load(joysprite_folder+"controller.png")

	return tex
