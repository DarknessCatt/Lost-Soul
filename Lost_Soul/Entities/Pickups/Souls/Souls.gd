extends Area2D

func _ready():
	randomize()

	for point in len($Body.polygon):
		$Body.polygon[point].x += rand_range(-5,5)
		$Body.polygon[point].y += rand_range(-2,2)

func _on_Souls_body_entered(_body):
	$Animation.play("collect")

func _on_Animation_finished(anim_name):
	#if anim_name == "collect":
	self.call_deferred("free")
