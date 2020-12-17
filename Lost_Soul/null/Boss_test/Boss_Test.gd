extends Node2D

func _ready():
	MusicHandler.MusicPlayer = $BG

func _on_Hero_dead():
	print("u dead")
