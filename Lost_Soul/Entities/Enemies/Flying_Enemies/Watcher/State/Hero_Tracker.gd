extends State

const dist : int = 180
const LEFT : Vector2 = Vector2(-dist, 0)
const RIGHT : Vector2 = Vector2(dist, 0)
const UP : Vector2 = Vector2(0, -dist-20)

onready var Flying : State = $"../Flying"

var swap : bool = true

func update(Watcher: KinematicBody2D, _delta : float) -> void:
	var dir : Vector2 = Watcher.hero.global_position - Watcher.global_position
	Watcher.body.rotation = dir.angle()

	if swap:

		# warning-ignore:integer_division
		if abs(dir.x) < dist/3:
			Flying.Point_To_Seek = UP
		elif sign(dir.x) > 0:
			Flying.Point_To_Seek = LEFT
		else:
			Flying.Point_To_Seek = RIGHT

		Flying.Point_To_Seek += Vector2(rand_range(-20,20),rand_range(-20,20))

		swap = false
		$Seek_Swap.start()

func _on_Seek_Swap_timeout():
	swap = true
