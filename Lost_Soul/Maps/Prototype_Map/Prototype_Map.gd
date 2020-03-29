extends Node2D

const camera_pos : Vector2 = Vector2(-4690,-250)
const camera_zoom : Vector2 = Vector2(6,6)

func _on_Church_body_entered(body):
	$MapCamera.current = true

	$Tween.stop_all()
	$Tween.interpolate_property($MapCamera, "position", $Hero/Camera.global_position, camera_pos, 4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MapCamera, "zoom", $Hero/Camera.zoom, camera_zoom, 4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Church_body_exited(body):
	$Hero/Camera.current = true
	$Hero/Camera.global_position = $MapCamera.global_position

	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "position", $Hero/Camera.position, Vector2(0, -75), 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Hero/Camera, "zoom", $MapCamera.zoom, Vector2(1,1), 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
