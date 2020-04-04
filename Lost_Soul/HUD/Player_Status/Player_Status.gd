extends MarginContainer

const HEART_COUNTER_RES : String = \
	"res://HUD/Player_Status/Components/Heart_Counter/Heart_Counter.tscn"


export(NodePath) var Character : NodePath
var Char_Node : Node2D

var heart_list : Array = []

func _ready():
	Char_Node = get_node(Character)
	$Order/Life_Bar.max_value = Char_Node.max_health
	$Order/Life_Bar.value = Char_Node.health

func _process(_delta):
	$Order/Life_Bar.value = Char_Node.health

func _increase_hearts():
	var heart = load(HEART_COUNTER_RES).instance()
	$Order/Heart_Uses.add_child(heart)
	heart_list.append(heart)

func _use_hearts(num : int):
	heart_list[num].get_child(0).play("Used")
