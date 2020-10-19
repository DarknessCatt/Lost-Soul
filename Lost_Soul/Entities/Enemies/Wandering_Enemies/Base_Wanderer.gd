extends Enemy_FSM

class_name Base_Wanderer

#Information
onready var body : Node2D = $Body

func _ready():
	cur_state = $States/Walking
	cur_state.enter(self)

#Functions
func change_animation(anim : String) -> void:
	$Body_Animations.play(anim)

func respawn() -> void:
	self._change_state($States/Walking)
	self.body.rotation = 0
	$Perception.rotation = 0
	.respawn()
