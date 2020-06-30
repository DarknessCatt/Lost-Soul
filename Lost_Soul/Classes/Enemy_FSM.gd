extends KinematicBody2D

class_name Enemy_FSM

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
func _physics_process(delta) -> void:
	cur_state.update(self, delta)

func _change_state(new_state : Node) -> void:
	cur_state.exit(self)
	cur_state = new_state
	cur_state.enter(self)

func spawn_souls() -> void:
	randomize()
	for i in souls:
		var new_soul = SOUL_RES.instance()
		var pos = Vector2(0, -65)
		pos.x += rand_range(-soul_x, soul_x)
		pos.y += rand_range(-20, 20)
		new_soul.position = self.position + pos
		self.get_parent().call_deferred("add_child", new_soul)
		yield(get_tree().create_timer(0.05), "timeout")

##Respawn
onready var original_position : Vector2 = self.position

func respawn() -> void:
	self.health = self.max_health
	self.position = self.original_position
