extends Node2D


func _ready():
	MusicHandler.MusicPlayer = $AudioStreamPlayer
	MusicHandler.play_music(load("res://Assets/BG_Music/Anttis/Anttis-instrumentals-Beat.ogg"), -20, 0.1)

func _on_Button_pressed():
	MusicHandler.play_music(load("res://Assets/BG_Music/Anttis/Anttis-instrumentals-1st-I-lost-my-money.ogg"))
