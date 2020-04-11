extends KinematicBody2D

#Perception
var Player : KinematicBody2D = null

##Functions
func _on_Player_Detected(p_body):
	Player = p_body
	$Perception/Eyes.call_deferred("set", "monitoring", false)

#Info
onready var body : Node2D = $Body

#Attributes
var max_health : int = 100
var health : int = max_health
var speed : Vector2 = Vector2(0,0)

##Signals
signal dead()

##Functions

func _hit(damage : int, force : int, _direction : Vector2):
	if health > 0:
		health -= damage

		if force > 0:
			self.speed = _direction.normalized()*force

		if health <= 0:
			emit_signal("dead")
			_die()

		else:
			self._change_state($States/Knockback)


func _die():
	on_cutscene = true
	self._change_anim("Death")

#FSM
onready var cur_state : Node  = $States/Idle
export(bool) var on_cutscene : bool = false

##Functions
func _clear_attack_polys():
	$Body/Hip/Torso/Left_Arm/Left_Hand/Left_Weapon.polygon = PoolVector2Array()
	$Body/Hip/Torso/Right_Arm/Right_Hand/Right_Weapon.polygon = PoolVector2Array()

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
