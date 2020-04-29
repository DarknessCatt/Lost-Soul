extends Node2D

func _process(_delta):
	$Info.set_text("X: " + str($Hero.speed.x) + "\nY: " + str($Hero.speed.y) + "\nS: " + str($Hero.cur_state.name))
