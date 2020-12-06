extends Control

func _ready():
	$List/Credits_Scroller.grab_focus()

func _on_Voltar():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Main_Menu/Main_Menu.tscn")
