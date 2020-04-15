extends MarginContainer

const HEART_COUNTER_RES : String = \
	"res://HUD/Player_Status/Components/Heart_Counter/Heart_Counter.tscn"


export(NodePath) var Character : NodePath
var Char_Node : Node2D

var heart_list : Array = []
var max_hearts : int = 0
var current_hearts : int = 0

func _ready():
	Char_Node = get_node(Character)
	$Order/Life_Bar.max_value = Char_Node.max_health
	$Order/Life_Bar.value = Char_Node.health

func _process(_delta):
	$Order/Life_Bar.value = Char_Node.health

	if Char_Node.max_crystal_heart > max_hearts:
		var heart = load(HEART_COUNTER_RES).instance()
		$Order/Heart_Uses.add_child(heart)
		heart_list.append(heart)

		if max_hearts > current_hearts:
			heart_list[current_hearts].get_child(0).play("Available")
			heart_list[max_hearts].get_child(0).play("Used")
			heart_list[max_hearts].get_child(0).seek(1.0)

		current_hearts += 1
		max_hearts += 1

	if Char_Node.crystal_heart != current_hearts:
		while Char_Node.crystal_heart > current_hearts:
			heart_list[current_hearts].get_child(0).play("Available")
			current_hearts += 1

		while Char_Node.crystal_heart < current_hearts:
			current_hearts -= 1
			heart_list[current_hearts].get_child(0).play("Used")
