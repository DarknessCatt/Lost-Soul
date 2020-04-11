extends KinematicBody2D

#Info
onready var body : Node2D = $Body

#Attributes
var max_health : int = 100
var health : int = max_health

var max_crystal_heart : int = 0
var crystal_heart : int = max_crystal_heart

var invencible : bool = false

##Signals
signal dead()
signal heart_collected()
signal heart_used(num)

##Functions
func _refresh():
	self.health = max_health
	self.crystal_heart = max_crystal_heart
	$Heart_Particles.restart()

func _hit(damage : int, force : int, _direction : Vector2):
	if not invencible:
		if health > 0:
			health -= damage

			if health <= 0:
				emit_signal("dead")

			elif force > 0:
				self.speed += _direction.normalized()*force
				self._change_state($States/Knockback)

func _die():
	on_cutscene = true
	self._change_anim("Death")

func _crystal_heart_collected():
	max_crystal_heart += 1
	crystal_heart += 1

	self.speed = Vector2(0,0)
	_change_state($States/OnGround)
	_change_anim("PowerUp")

	on_cutscene = true
	emit_signal("heart_collected")

func _use_heart():
	if crystal_heart > 0:
		crystal_heart -= 1
		health = max_health
		$Heart_Particles.restart()
		emit_signal("heart_used", crystal_heart)

func _powerup_end():
	on_cutscene = false


#Movement
var speed : Vector2 = Vector2(0,0)

#FSM
onready var cur_state : Node  = $States/Falling
export(bool) var on_cutscene : bool = false

##Functions
func _clear_attack_polys():
	$Body/Hip/Torso/Left_Arm/Left_Hand/Left_Weapon.polygon = PoolVector2Array()
	$Body/Hip/Torso/Right_Arm/Right_Hand/Right_Weapon.polygon = PoolVector2Array()
	$Body/Hip/Right_Leg/Right_Shin/Right_Foot/Right_Foot_Weapon.polygon = PoolVector2Array()

func _disable_hitboxes():
	for atk in $Body/Hitboxes.get_children():
		for hitbox in atk.get_children():
			for collision in hitbox.get_children():
				collision.call_deferred("set", "disabled", true)

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
