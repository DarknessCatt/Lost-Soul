extends Enemy_FSM

var Player : KinematicBody2D = null
onready var body : Node2D = $Body

#Multi State Info
enum surface_positions {Ceiling, Wall, Ground}
export(surface_positions) var cur_surface : int = surface_positions.Ground

var original_rotation : float = 0

func _hit(damage : int, force : int, direction : Vector2):
	if not invencible:
		self.speed = force*direction.normalized()
		self.speed.y = min(-400, self.speed.y)

		health -= damage

		if health > 0:
			self._change_state($States/Knockback)

		else:
			self._change_state($States/Dead)
			self.spawn_souls()

func _ready():
	cur_state = $States/Idle
	cur_state.enter(self)
	original_rotation = self.rotation
	self.rotation = 0
	$Body.rotation = original_rotation

func change_animation(anim : String) -> void:
	$Animation.play(anim)

func align_floor() -> void:
	if self.get_slide_count() == 0:
		return 

	var total_normal : Vector2 = Vector2.ZERO

	for i in self.get_slide_count():
		#Ignore the Player
		var collision = self.get_slide_collision(i)
		if collision.collider.get_collision_layer_bit(0) != true:
			total_normal += collision.normal

	self.body.rotation = total_normal.angle() + 1.57

	self.position += total_normal.normalized()*10

func change_boxes(value : bool) -> void:
	$Body/Body/Hitbox.call_deferred("set", "monitorable", value)
	$Body/Body/Hurtbox.call_deferred("set", "monitoring", value)
	
func respawn() -> void:
	$Body.modulate = Color(1,1,1,1)
	$Body/Body/Head.rotation = 0
	$Body.rotation = original_rotation
	self.Player = null
	# warning-ignore:return_value_discarded
	self.move_and_slide(Vector2.ZERO)
	self._change_state($States/Idle)
	.respawn()
