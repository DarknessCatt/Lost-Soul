extends Control

var changing_key : bool = false
var new_event_type
var new_event : InputEvent = null
var current_keybind = null

signal menu_exited()

func _on_Save_and_Exit_pressed():
	emit_signal("menu_exited")

func _on_Reset():
	$Confirm_Reset.show()

func _on_Confirm_pressed():
	$Confirm_Reset.hide()
	InputMap.load_from_globals()
	for keybind in $Controls/Menu.get_children():
		keybind.update_buttons()

func _on_Cancel_pressed():
	$Confirm_Reset.hide()

func _on_key_change_request(keybind):
	current_keybind = keybind
	changing_key = true
	new_event = null
	$Change_Key.show()
	$Change_Key/Windows/Window/Titulo.text = "Aperte um botão para a ação "+keybind.action
	$Change_Key/Windows/Window/Input/Controller.hide()
	$Change_Key/Windows/Window/Input/Keyboard.hide()

func _input(event):
	if changing_key and event.is_pressed():
		if event is InputEventKey:
			$Change_Key/Windows/Window/Input/Controller.hide()
			$Change_Key/Windows/Window/Input/Keyboard.show()
			$Change_Key/Windows/Window/Input/Keyboard.text = OS.get_scancode_string(event.scancode)
			new_event_type = InputEventKey
			new_event = event

		elif event is InputEventJoypadButton:
			$Change_Key/Windows/Window/Input/Controller.show()
			$Change_Key/Windows/Window/Input/Keyboard.hide()
			$Change_Key/Windows/Window/Input/Controller.texture = JoyButtonSpriter.get_sprite(event.button_index)
			new_event_type = InputEventJoypadButton
			new_event = event

		elif event is InputEventJoypadMotion and event.axis_value != 0:
			$Change_Key/Windows/Window/Input/Controller.show()
			$Change_Key/Windows/Window/Input/Keyboard.hide()
			$Change_Key/Windows/Window/Input/Controller.texture = \
				JoyButtonSpriter.get_sprite(JoyButtonSpriter.get_motion_id(event))
			new_event_type = InputEventJoypadButton
			new_event = event

func _on_Salve_pressed():
	changing_key = false
	$Change_Key.hide()

	if new_event != null:
		var action = current_keybind.action
		for event in InputMap.get_action_list(action):
			if event is new_event_type:
				InputMap.action_erase_event(action, event)
				InputMap.action_add_event(action, new_event)
				current_keybind.update_buttons()

func _on_Exit_pressed():
	changing_key = false
	$Change_Key.hide()
