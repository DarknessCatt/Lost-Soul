extends Panel

func _on_DialogueBox_dialogue_end():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Main_Menu/Main_Menu.tscn")
