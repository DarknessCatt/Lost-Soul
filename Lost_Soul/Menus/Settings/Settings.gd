extends Control

signal menu_exited()

func _on_master_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_music_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BG"), value)

func _on_sfx_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_Music_Button_pressed():
	$Menu/Music_Volume/Teste/Som.play()

func _on_SFX_Button_pressed():
	$Menu/SFX_Volume/Teste/Som.play()


func _on_Keybinds_pressed():
	$Keybinding.show()
	$Menu.hide()

func _on_Keybinding_exited():
	$Keybinding.hide()
	$Menu.show()


func _on_Sair_pressed():
	emit_signal("menu_exited")
