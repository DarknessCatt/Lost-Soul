extends KinematicBody2D

#Info
onready var body : Node2D = $Body
onready var buffer : Node = $Buffer

#Attributes
var max_health : int = 100
var health : int = max_health

var max_energy : int = 30
var energy : int = max_energy

var souls : int = 0
var level : int = 1

var max_crystal_heart : int = 0
var crystal_heart : int = max_crystal_heart

var blocking : bool = false
var invencible : bool = false setget set_invencible
const KNOCKBACK_STRENGH : int = 1200

#POWERS
export(Dictionary) var available_powers : Dictionary = {"dash" : false}

const DASH_COST : int = 10

##Signals
signal dead()
signal heart_collected()
signal heart_used(num)

##Functions
func _refresh() -> void:
	self.health = max_health
	self.energy = max_energy
	self.crystal_heart = max_crystal_heart
	$Heart_Particles.restart()

func _on_attack_hit(energy_restored):
	energy += energy_restored
	# warning-ignore:narrowing_conversion
	energy = min(max_energy, energy)

func _hit(damage : int, _force : int, _direction : Vector2) -> void:
	if not invencible and cutscene == cutscene_type.NONE:
		if not blocking:
			if health > 0:
				health -= damage

				if health <= 0:
					emit_signal("dead")

				else:
					var kb : Vector2 = _calculate_knockback()
					var dir = self.global_position - kb

					self.speed = dir.normalized()*KNOCKBACK_STRENGH
					self._change_state($States/Knockback)

		else:
			energy -= damage

			if energy <= 0:
				health += energy
				energy = 0

				var kb : Vector2 = _calculate_knockback()
				var dir = self.global_position - kb

				self.speed = dir.normalized()*KNOCKBACK_STRENGH
				self._change_state($States/Knockback)

			else:
				self.change_hurtboxes(false)
				$Misc_Animations.play("blocked")

func _calculate_knockback() -> Vector2:
	var kb : Vector2 = Vector2(0,0)
	var num : int = 0

	for area  in $Body/Hip/Torso/Torso_Hurtbox.get_overlapping_areas():
		kb += area.global_position
		num +=1

	for area in $Body/Hip/Left_Leg/L_Leg_Hurtbox.get_overlapping_areas():
		kb += area.global_position
		num +=1

	for area in $Body/Hip/Left_Leg/Left_Shin/L_Shin_Hurtbox.get_overlapping_areas():
		kb += area.global_position
		num +=1

	for area in $Body/Hip/Right_Leg/R_Leg_Hurtbox.get_overlapping_areas():
		kb += area.global_position
		num +=1

	for area in $Body/Hip/Right_Leg/Right_Shin/R_Shin_Hurtbox.get_overlapping_areas():
		kb += area.global_position
		num +=1

	return (kb/num)

func set_invencible(value : bool):
	self.change_hurtboxes(not value)
	invencible = value
	if value: $Misc_Animations.play("inv")

func change_hurtboxes(value : bool) -> void:
	$Body/Hip/Torso/Torso_Hurtbox.call_deferred("set", "monitoring", value)
	$Body/Hip/Left_Leg/L_Leg_Hurtbox.call_deferred("set", "monitoring", value)
	$Body/Hip/Left_Leg/Left_Shin/L_Shin_Hurtbox.call_deferred("set", "monitoring", value)
	$Body/Hip/Right_Leg/R_Leg_Hurtbox.call_deferred("set", "monitoring", value)
	$Body/Hip/Right_Leg/Right_Shin/R_Shin_Hurtbox.call_deferred("set", "monitoring", value)
	yield(get_tree(), "idle_frame")

func _on_Invencibility_timeout():
	self.invencible = false

func die() -> void:
	self.cutscene = cutscene_type.FULL
	self._change_anim("Death")

func _soul_collected(quantity : int) -> void:
	self.souls += quantity

func _crystal_heart_collected() -> void:
	max_crystal_heart += 1
	crystal_heart += 1

	self.speed = Vector2(0,0)

	_change_anim("PowerUp")
	emit_signal("heart_collected")

func _use_heart() -> void:
	if crystal_heart > 0:
		crystal_heart -= 1
		health = max_health
		$Heart_Particles.restart()
		emit_signal("heart_used", crystal_heart)

func can_dash() -> bool:
	if self.available_powers.dash and self.energy >= DASH_COST:
		self.energy -= DASH_COST
		return true

	return false

#Movement
var speed : Vector2 = Vector2(0,0)

#FSM
var cur_state : Node
enum cutscene_type {NONE, PHYSICS, FULL}
export(cutscene_type) var cutscene : int = cutscene_type.NONE setget set_cutscene

func set_cutscene(new_value : int):
	cutscene = new_value
	
	if cutscene == cutscene_type.PHYSICS:
		self._change_state($States/Cutscene)

	else:
		self._change_state($States/Playing)

##Functions
func _ready():
	cur_state = $States/Playing
	cur_state.enter(self)

func _clear_attack_polys() -> void:
	$Body/Hip/Torso/Left_Arm/Left_Hand/Left_Weapon.polygon = PoolVector2Array()
	$Body/Hip/Torso/Right_Arm/Right_Hand/Right_Weapon.polygon = PoolVector2Array()
	$Body/Hip/Right_Leg/Right_Shin/Right_Foot/Right_Foot_Weapon.polygon = PoolVector2Array()

func _disable_hitboxes() -> void:
	for atk in $Body/Hitboxes.get_children():
		for hitbox in atk.get_children():
			for collision in hitbox.get_children():
				collision.call_deferred("set", "disabled", true)

func _input(event):
	if cutscene == cutscene_type.NONE:
		if event.is_action_pressed("hero_heart"):
			self._use_heart()
		else:
			cur_state.input(self, event)

func _physics_process(delta):
	if cutscene != cutscene_type.FULL:
		cur_state.update(self, delta)

func _change_state(new_state : Node):
	cur_state.exit(self)
	cur_state = new_state
	cur_state.enter(self)

func _change_anim(new_anim : String):
	$Body_Animations.play(new_anim)

func _reset_anim(new_anim : String):
	$Body_Animations.stop()
	$Body_Animations.play(new_anim)
