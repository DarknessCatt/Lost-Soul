extends Node2D

export(NodePath) var status : NodePath
onready var status_node : Node = get_node(status)

func _process(_delta):
	$Info.set_text(str(status_node.name) + "\nX: " + str(status_node.speed.x) + "\nY: " + str(status_node.speed.y) + "\nS: " + str(status_node.cur_state.name))

func _on_Checkpoint_reached(_checkpoint):
	$Test_Wanderer.respawn()
	$Lost_Soul.respawn()
	$Fly_Test.respawn()
	$Watcher.respawn()


