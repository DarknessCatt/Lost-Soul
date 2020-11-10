tool
extends Node2D

export(int, 0 , 2) var desired_rank : int = 0 setget change_rank
export(NodePath) var enemies_node_path : NodePath setget set_enemies_node
export(bool) var show_all : bool = false setget show_all_enemies

var enemies_node : Node2D

func _ready():
	if not Engine.editor_hint:
		self.call_deferred("free")

func show_all_enemies(value : bool):
	show_all = value

	if show_all:
		visualize_all(enemies_node)

	elif enemies_node != null:
		visualize_rank(enemies_node)

func change_rank(new_rank : int):
	desired_rank = new_rank
	if enemies_node != null and not show_all:
		visualize_rank(enemies_node)

func set_enemies_node(new_node_path : NodePath):
	enemies_node_path = new_node_path

	if enemies_node_path != "":
		enemies_node = self.get_node(enemies_node_path)

		if enemies_node != null and not show_all:
			visualize_rank(enemies_node)

	else:
		enemies_node = null

func visualize_rank(node : Node2D) -> void:
	for child in node.get_children():

		if child is Enemy_FSM:
			if child.allowed_ranks[desired_rank]: child.show()
			else: child.hide()

		else:
			visualize_rank(child)

func visualize_all(node : Node2D) -> void:
	for child in node.get_children():

		if child is Enemy_FSM:
			child.show()

		else:
			visualize_all(child)
