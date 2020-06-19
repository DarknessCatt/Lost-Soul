extends FSM

#Information
const SOUL_RES = preload("res://Entities/Pickups/Souls/Souls.tscn")
var body : Node2D
var hero : KinematicBody2D
onready var animation : AnimationNodeStateMachinePlayback = \
		$Animation_Player.get("parameters/playback")
onready var effects : AnimationPlayer = $Body_Effects

export(int) var horizontal_space = 0
export(int) var downwards_space = 0

#Signals
signal intro_ended

const invencible : bool = false

##Functions
func _hit(damage : int, force : int, direction : Vector2) -> void:
	cur_state.hit(damage, force, direction)

func _ready():
	body = $Body
	cur_state = $States/Idle
	self.modulate.a = 0

func _input(_event):
	pass

func intro(player : KinematicBody2D):
	hero = player
	cur_state = $States/Intro
	$Animation_Player.active = true
	cur_state.enter(self)

func spawn_souls() -> void:
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
