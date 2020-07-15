extends State

var Player_Node : KinematicBody2D

onready var move_state : ConcurrentState = $OnGround
onready var action_state : ConcurrentState = $Idle

func enter(Player : KinematicBody2D) -> void:
	self.Player_Node = Player

	if Player.is_on_floor():
		move_state = $OnGround

	else:
		move_state = $Falling

	action_state = $Idle

	move_state.enter(self, Player_Node)
	action_state.enter(self, Player_Node)

func change_move_state(new_state : ConcurrentState):
	move_state.exit(self, Player_Node)
	move_state = new_state
	move_state.enter(self, Player_Node)
	action_state.move_state_changed(self, Player_Node)

func change_action_state(new_state : ConcurrentState):
	action_state.exit(self, Player_Node)
	action_state = new_state
	action_state.enter(self, Player_Node)

func exit(Player : KinematicBody2D) -> void:
	move_state.exit(self, Player_Node)
	action_state.exit(self, Player_Node)

func update(Player: KinematicBody2D, delta : float) -> void:
	move_state.update(self, Player, delta)
	action_state.update(self, Player, delta)

func input(Player: KinematicBody2D, event : InputEvent) -> void:
	move_state.input(self, Player, event)
	action_state.input(self, Player, event)
