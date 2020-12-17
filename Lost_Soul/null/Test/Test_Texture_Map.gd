extends Node2D

var maps : Array = []

func _ready():
	maps.append($Maps/Map2)
	maps.append($Maps/Map3)
	maps.append($Maps/Map4)

	for map in maps:
		$Maps.remove_child(map)

func _on_Map1_Exit_body_entered(_body):
	$Maps.call_deferred("remove_child", $Maps/Map1)
	$Maps.call_deferred("add_child", maps.pop_front())

func _on_Map2_Exit_body_entered(_body):
	$Maps.call_deferred("remove_child", $Maps/Map2)
	$Maps.call_deferred("add_child", maps.pop_front())

func _on_Map3_Exit_body_entered(_body):
	$Maps.call_deferred("remove_child", $Maps/Map3)
	$Maps.call_deferred("add_child", maps.pop_front())

func _on_Map4_Exit_body_entered(_body):
	$Maps.call_deferred("remove_child", $Maps/Map4)
