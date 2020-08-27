extends HBoxContainer

export(String) var action : String = "" setget change_action

signal key_change_request(keybind)

func change_action(new_action : String) -> void:
	assert(InputMap.has_action(new_action))
	action = new_action
	update_buttons()

func update_buttons() -> void:
	assert(InputMap.has_action(action))

	$Action.text = self.action

	for event in InputMap.get_action_list(action):
		assert(event is InputEventKey or event is InputEventJoypadButton)

		if event is InputEventKey:
			$Keyboard_Button.text = OS.get_scancode_string(event.scancode)

		elif event is InputEventJoypadButton:
			$Control_Button/Sprite.texture = JoyButtonSpriter.get_sprite(event.button_index)

func _ready():
	update_buttons()

func _on_button_pressed():
	emit_signal("key_change_request", self)
