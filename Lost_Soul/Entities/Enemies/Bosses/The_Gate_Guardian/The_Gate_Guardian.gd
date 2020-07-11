extends FSM

#Resources
const SOUL_RES : Resource = preload("res://Entities/Pickups/Souls/Souls.tscn")
const BULLET_RES : Resource = preload("res://Entities/Enemies/Bosses/The_Gate_Guardian/Components/Boss_Shoot.tscn")

#Information
var body : Node2D
var hero : KinematicBody2D
onready var animation : AnimationNodeStateMachinePlayback = \
		$Animation_Player.get("parameters/playback")
onready var effects : AnimationPlayer = $Body_Effects
var original_position : Vector2

export(int) var horizontal_space = 0
export(int) var downwards_space = 0

#Signals
signal intro_ended
signal dead

const invencible : bool = false

##Functions
func _hit(damage : int, force : int, direction : Vector2) -> void:
	cur_state.hit(damage, force, direction)

func _ready():
	body = $Body
	cur_state = $States/Idle
	original_position = self.position
	self.modulate.a = 0

func intro(player : KinematicBody2D):
	hero = player
	cur_state = $States/Intro
	$Animation_Player.active = true
	cur_state.enter(self)

func respawn() -> void:
	self.position = original_position
	self._change_state($States/Idle)
	self.modulate.a = 0
	hero = null
	$Animation_Player.active = false
	$Body_Anim.play("rest")
	$Wall.stop()
	$Shoot.stop()
	$Charge.stop()
	$Screech.stop()

# Called by "Atk" animations

func single_shot() -> void:
	var bullet = BULLET_RES.instance()
	bullet.SPEED = 700
	bullet.position = self.position + self.body.get_node("Eye/Iris").position.rotated(self.body.rotation)
	bullet.rotation = self.body.rotation
	self.get_parent().add_child(bullet)

func spread_shot() -> void:

	var inicial_rad : float = -1.04
	var increment : float = 0.52

	for i in 5:
		var bullet = BULLET_RES.instance()
		bullet.SPEED = 350
		bullet.position = self.position + self.body.get_node("Eye/Iris").position.rotated(self.body.rotation)
		bullet.rotation = self.body.rotation + inicial_rad + i*increment
		self.get_parent().add_child(bullet)

func rain_shot() -> void:
	var inicial_rad : float = -0.12
	var increment : float = 0.12

	for i in 3:
		var bullet = BULLET_RES.instance()
		bullet.SPEED = 1000
		bullet.position = self.position + self.body.get_node("Eye/Iris").position.rotated(self.body.rotation)
		bullet.rotation = self.body.rotation + inicial_rad + i*increment + 1.57 + rand_range(-0.05, 0.05)
		self.get_parent().add_child(bullet)

# Called by "Dead" animation
func spawn_souls() -> void:
	emit_signal("dead")
	randomize()
	for i in 25:
		var new_soul = SOUL_RES.instance()
		new_soul.Soul_Value = 2
		var pos = Vector2(0, -65)
		pos.x += rand_range(-44, 44)
		pos.y += rand_range(-20, 20)
		new_soul.position = self.position + pos
		self.get_parent().call_deferred("add_child", new_soul)
		yield(get_tree().create_timer(0.03), "timeout")
