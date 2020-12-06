extends Node

onready var Tweener : Tween = Tween.new()
var MusicPlayer : AudioStreamPlayer = null setget set_MusicPlayer

func set_MusicPlayer(new_player : AudioStreamPlayer) -> void:
	assert(MusicPlayer == null, "Music Player already set!")
	MusicPlayer = new_player
	MusicPlayer.add_child(Tweener)
	yield(get_tree(), "idle_frame")

func play_music(new_music : AudioStream, volume : float = 0.0, fade : float = 0.2) -> void:
	if new_music == MusicPlayer.stream: return
	# warning-ignore:return_value_discarded
	Tweener.interpolate_property(MusicPlayer, "volume_db",
								MusicPlayer.volume_db, -80, fade)
	# warning-ignore:return_value_discarded
	Tweener.start()
	yield(Tweener, "tween_all_completed")

	MusicPlayer.stop()
	MusicPlayer.stream = new_music
	MusicPlayer.play()

	# warning-ignore:return_value_discarded
	Tweener.interpolate_property(MusicPlayer, "volume_db",
								MusicPlayer.volume_db, volume, fade)
	# warning-ignore:return_value_discarded
	Tweener.start()
	yield(Tweener, "tween_all_completed")

func toggle_pause():
	MusicPlayer.stream_paused = not MusicPlayer.stream_paused
