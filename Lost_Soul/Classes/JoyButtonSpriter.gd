class_name JoyButtonSpriter

const joysprite_folder = "res://Assets/controller/"

static func is_key_valid(button : int) -> bool:
	match(button):
		0, 1, 2, 3, 4, 5, 6, 7, 12 ,13, 14, 15:
			return true

		_:
			return false

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
		12:
			tex = load(joysprite_folder+"controller_digi_up.png")
		13:
			tex = load(joysprite_folder+"controller_digi_down.png")
		14:
			tex = load(joysprite_folder+"controller_digi_left.png")
		15:
			tex = load(joysprite_folder+"controller_digi_right.png")
		_:
			tex = load(joysprite_folder+"controller.png")

	return tex
