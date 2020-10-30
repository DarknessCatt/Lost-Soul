extends Enemy_FSM

var Player : KinematicBody2D = null
onready var body : Node2D = $Body

#Multi State Info
enum surface_positions {Ceiling, Wall, Ground}
export(surface_positions) var cur_surface : int = surface_positions.Ground

func _ready():
	cur_state = $States/Idle
	cur_state.enter(self)

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
