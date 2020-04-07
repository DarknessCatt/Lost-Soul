extends KinematicBody2D

#Info
onready var body : Node2D = $Body

#Attributes
var max_health : int = 100
var health : int = max_health

##Signals
signal dead()
##Functions

func _hit(damage : int, force : int, _direction : Vector2):
	if health > 0:
		health -= damage

		if health <= 0:
			emit_signal("dead")

		if force > 0:
			self.speed += _direction.normalized()*force

func _die():
	on_cutscene = true
	self._change_anim("Death")


#Movement
var speed : Vector2 = Vector2(0,0)

#FSM
onready var cur_state : Node  = $States/Falling
export(bool) var on_cutscene : bool = false

##Functions
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
