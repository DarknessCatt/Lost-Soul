extends Area2D

export(String) var action : String
export(bool) var disabled : bool = false

var controller : bool = false

func _ready():
	self.modulate.a = 0

	update_buttons()
	$Keyboard.show()
	$Controller.hide()
	controller = false

func update_buttons() -> void:
	assert(InputMap.has_action(action))

	for event in InputMap.get_action_list(action):
		assert(event is InputEventKey or event is InputEventJoypadButton)

		if event is InputEventKey:
			$Keyboard.text = OS.get_scancode_string(event.scancode)

		elif event is InputEventJoypadButton:
			$Controller.texture = JoyButtonSpriter.get_sprite(event.button_index)

func _on_body_entered(_body):
	if not disabled:
		$Tween.stop_all()
		$Tween.interpolate_property(self, "modulate:a", self.modulate.a, 1, 0.5)
		$Tween.start()

func _on_body_exited(_body):
	if not disabled:
		$Tween.stop_all()
		$Tween.interpolate_property(self, "modulate:a", self.modulate.a, 0, 0.5)
		$Tween.start()

func _input(event):
	if controller and event is InputEventKey:
		$Keyboard.show()
		$Controller.hide()
		controller = false

	elif not controller and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		$Keyboard.hide()
		$Controller.show()
		controller = true
