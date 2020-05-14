extends VBoxContainer

export(NodePath) var Character : NodePath
var Char_Node : Node2D

var total : int = 0 setget set_total
var collected : int = 0 setget set_collected

#mini FSM
enum {EQUAL, DELAY, INC}
var state : int = EQUAL

func set_total(value : int):
	$Total.text = str(value)
	total = value

func set_collected(value : int):
	$Collected.text = "+" + str(value)
	collected = value

func _ready():
	self.hide()
	Char_Node = get_node(Character)
	self.total = Char_Node.souls

func _process(delta):
	var cur_souls = Char_Node.souls

	if state == EQUAL:
		if cur_souls != total:
			self.show()
			self.collected = cur_souls - total
			state = DELAY
			$Delay.start()
			$End.stop()

	elif state == DELAY:

		if cur_souls - total != collected:
			self.collected = cur_souls - total
			$Delay.start()

	else:
		if cur_souls - total != collected:
			self.collected = cur_souls - total

		if collected == 0:
			state = EQUAL
			$Inc.stop()
			$End.start()

func _on_Delay_timeout():
	state = INC
	$Inc.start()

func _on_Inc_timeout():
	self.total += 1
	self.collected -= 1

func _on_End_timeout():
	self.hide()