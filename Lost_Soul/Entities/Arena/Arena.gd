extends Node2D

var player : KinematicBody2D = null

var triggered : bool = false

func _on_Trigger_body_entered(body):
	self.show()
	triggered = true
	$Placeholder_White.set_collision_layer_bit(4, true)
	player = body

	$Arena_Camera.current = true
	player.get_node("Camera2D").hide()
	$Arena_Camera.global_position = player.get_node("Camera2D").global_position
	$Tween.interpolate_property($Arena_Camera, "position",
							   $Arena_Camera.position, Vector2(0,0),
							   0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Placeholder_White, "modulate:a",
							   0, 1, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	$Trigger.call_deferred("set", "monitoring", false)

func _ready():
	self.hide()

func _restart():
	if triggered:
		self.hide()

		self.triggered = false
		$Trigger.call_deferred("set", "monitoring", true)

		$Placeholder_White.set_collision_layer_bit(4, false)

		var player_cam : Camera2D = player.get_node("Camera2D")

		player_cam.show()
		player_cam.current = true
		player_cam.position = Vector2(0,-75)

func _ended():
	self.hide()
	$Placeholder_White.set_collision_layer_bit(4, false)

	var player_cam : Camera2D = player.get_node("Camera2D")

	player_cam.show()
	player_cam.current = true
	player_cam.global_position = $Arena_Camera.global_position
	$Tween.interpolate_property(player_cam, "position",
							   player_cam.position, Vector2(0,-75),
							   0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
