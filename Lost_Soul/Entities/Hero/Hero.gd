extends KinematicBody2D

#Info
onready var body : Node2D = $Body

#Attributes
var max_health : int = 100
var health : int = max_health

var max_crystal_heart : int = 0
var crystal_heart : int = max_crystal_heart

#Movement
var speed : Vector2 = Vector2(0,0)

#Attributes
func _crystal_heart_collected():
	max_crystal_heart += 1
	crystal_heart += 1

	self.speed = Vector2(0,0)
	_change_state($States/OnGround)
	_change_anim("PowerUp")

	on_cutscene = true

func _use_heart():
	if crystal_heart > 0:
		crystal_heart -= 1
		health = max_health
		$Misc_Animations.play("Use_Heart")

func _powerup_end():
	on_cutscene = false

#FSM
onready var cur_state : Node  = $States/Falling
export(bool) var on_cutscene : bool = false

func _input(event):
	if not on_cutscene:

		if event.is_action_pressed("hero_heart"):
			self._use_heart()
		else:
			cur_state.input(self, event)

func _physics_process(delta):
	if not on_cutscene:
		cur_state.update(self, delta)

func _change_state(new_state : Node):
	cur_state.exit(self)
	cur_state = new_state
	cur_state.enter(self)

func _change_anim(new_anim : String):
	if $Body_Animations.current_animation == new_anim:
		$Body_Animations.stop()

	$Body_Animations.play(new_anim)
