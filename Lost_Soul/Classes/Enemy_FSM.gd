extends KinematicBody2D

class_name Enemy_FSM

export(Array) var allowed_ranks = [false, false, false]

const SOUL_RES = preload("res://Entities/Pickups/Souls/Souls.tscn")
export(float) var soul_x = 40

#Attributes
export(int) var max_health : int = 5
onready var health : int = max_health

export(int) var souls : int = 0

var invencible : bool = false

#Movement
var speed : Vector2 = Vector2(0,0)

#FSM
onready var cur_state : Node

##Functions
func _die() -> void:
	pass

func _physics_process(delta) -> void:
	if not Engine.editor_hint:
		cur_state.update(self, delta)

func _change_state(new_state : Node) -> void:
	if not Engine.editor_hint:
		cur_state.exit(self)
		cur_state = new_state
		cur_state.enter(self)

func spawn_souls() -> void:
	if not Engine.editor_hint:
		if souls%2 == 1:
			_spawn_single_soul()

		# warning-ignore:integer_division
		for i in floor(souls/2):
			_spawn_single_soul(2)

func _spawn_single_soul(value = 1):
	if not Engine.editor_hint:
		var new_soul = SOUL_RES.instance()
		new_soul.Soul_Value = value
		new_soul.position = self.position + Vector2(rand_range(-soul_x, soul_x), -60)
		self.get_parent().call_deferred("add_child", new_soul)
		yield(get_tree().create_timer(0.05), "timeout")

##Respawn
onready var original_position : Vector2 = self.position

func respawn() -> void:
	if not Engine.editor_hint:
		self.health = self.max_health
		self.position = self.original_position
