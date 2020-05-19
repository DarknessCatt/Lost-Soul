extends Area2D

var activated : bool = false

func _ready():
	self.modulate.a = 1

func _on_Hidden_Area_body_entered(_body):
	if not activated:
		activated = true
		$Tween.interpolate_property(self, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
