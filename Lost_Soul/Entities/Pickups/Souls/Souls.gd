extends Area2D

export(int) var Soul_Value : int = 1

func _ready():
	for point in len($Body.polygon):
		$Body.polygon[point].x += rand_range(-5,5)
		$Body.polygon[point].y += rand_range(-2,2)

	$Float_Checker.cast_to.y += rand_range(-10, 10)

func _physics_process(delta):
	if $Float_Checker.get_collider() == null:
		self.position.y += 50*delta

func _on_Souls_body_entered(body):
	$Animation.play("collect")
	body._soul_collected(Soul_Value)

func _on_Animation_finished(anim_name):
	if anim_name == "spawned":
		$Animation.play("idle")
		$Animation.seek(rand_range(0,4))

	elif anim_name == "collect":
		self.call_deferred("free")

func respawn() -> void:
	self.call_deferred("free")
