tool
extends Enemy_FSM

const BULLET_RES : Resource = preload("res://Entities/Enemies/Wall_Enemies/Spitter/Components/Spitter_Shoot.tscn")

enum dir {LEFT = -1, RIGHT = 1}
export(dir) var look_direction = dir.RIGHT setget set_direction
export(int) var look_distance = 20 setget set_dist

##Editor
func set_direction(new_dir : int):
	$Body.scale.x = new_dir
	look_direction = new_dir
	$Vision.cast_to.x = look_distance*look_direction

func set_dist(new_dist : int):
	$Vision.cast_to.x = new_dist*look_direction
	look_distance = new_dist

onready var vision : RayCast2D = $Vision

func _ready():
	if not Engine.editor_hint:
		cur_state = $States/Idle
		cur_state.enter(self)

func _hit(damage : int, _force : int, _direction : Vector2):
	health -= damage

	if health <= 0:
		self._change_state($States/Dead)

func shoot():
	var bullet = BULLET_RES.instance()
	bullet.position = self.position
	bullet.position.x += 10*look_direction
	if look_direction == dir.LEFT:
		bullet.rotation = 3.14
	self.get_parent().add_child(bullet)

func change_animation(anim : String) -> void:
	$Body_Animations.play(anim)

func respawn() -> void:
	.respawn()
	self._change_state($States/Idle)
	$Body.modulate = Color("ffffff")
	$Hitbox.call_deferred("set", "monitorable", true)
	$Hurtbox.call_deferred("set", "monitoring", true)
	$Hurtbox.call_deferred("set", "monitorable", true)
