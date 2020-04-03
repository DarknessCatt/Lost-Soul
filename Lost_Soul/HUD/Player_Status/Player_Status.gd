extends MarginContainer

const HEART_COUNTER_RES : String = \
	"res://HUD/Player_Status/Components/Heart_Counter/Heart_Counter.tscn"


var heart_list : Array = []

func _increase_hearts():
	var heart = load(HEART_COUNTER_RES).instance()
	$Order/Heart_Uses.add_child(heart)
	heart_list.append(heart)
