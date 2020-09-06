extends Control

export(String) var game_scene : String
export(String) var credits_scene : String

func _on_New_Game_pressed():
	get_tree().change_scene(game_scene)

func _on_Credits_pressed():
	get_tree().change_scene(credits_scene)

func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$Menu.hide()
	$Settings.show()

func _on_Settings_exited():
	$Menu.show()
	$Settings.hide()