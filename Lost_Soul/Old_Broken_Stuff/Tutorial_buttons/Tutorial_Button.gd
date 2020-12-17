extends Node2D

var controller : bool = false

func _ready():
	assert(self.get_child_count() == 2)

func _input(event):
	if controller and event is InputEventKey:
		self.get_child(0).show()
		self.get_child(1).hide()
		controller = false

	elif not controller and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		self.get_child(1).show()
		self.get_child(0).hide()
		controller = true
