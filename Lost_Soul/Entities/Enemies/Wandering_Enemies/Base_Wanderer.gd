extends Enemy_FSM

class_name Base_Wanderer

#Information
onready var body : Node2D = $Body

func _ready():
	cur_state = $States/Walking
	cur_state.enter(self)

#Functions
func change_animation(anim : String) -> void:
	$Body_Animations.play(anim)

func respawn() -> void:
	self._change_state($States/Walking)
	self.body.rotation = 0
	$Perception.rotation = 0
	.respawn()

func align_floor(path_checker : RayCast2D) -> void:
	var total_normal : Vector2 = Vector2.ZERO

	for i in self.get_slide_count():
		#Ignore the Player
		var collision = self.get_slide_collision(i)
		if collision.collider.get_collision_layer_bit(0) != true:
			total_normal += collision.normal

	self.body.rotation = total_normal.angle() + 1.57
	path_checker.get_parent().rotation = total_normal.angle() + 1.57
