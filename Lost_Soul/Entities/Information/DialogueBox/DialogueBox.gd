extends Panel

signal dialogue_end()

enum {talking, waiting, end}
var state : int

export(float) var Delay_Per_Letter : float = 0.075
export(Array, String, MULTILINE) var Dialogue : Array = []

var dialogue_line : int = 0

func _ready():
	self.clear()

func clear():
	self.hide()
	state = end

func begin_dialogue():
	assert(state == end, "DialogueBox: Beginning unfinished dialogue.")
	self.show()
	state = talking
	self.dialogue_line = 0
	write_line()

func write_line():
	$Label.text = Dialogue[self.dialogue_line]
	$Tween.interpolate_property($Label, "percent_visible", 0, 1, $Label.text.length()*Delay_Per_Letter)
	$Tween.start()

func _on_Tween_all_completed():
	assert(state == talking, "DialogueBox: Tween ended while not talking.")
	state = waiting

func _input(event):
	if event.is_action_pressed("hero_jump"):

		if state == waiting:
			self.dialogue_line += 1
			$Label.percent_visible = 0

			if self.dialogue_line == Dialogue.size():
				self.clear()
				self.emit_signal("dialogue_end")
				return

			state = talking
			write_line()

		elif state == talking:
			$Tween.stop_all()
			state = waiting
			$Label.percent_visible = 1
