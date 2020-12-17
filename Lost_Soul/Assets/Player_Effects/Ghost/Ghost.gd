extends Node2D

var player_body : Node2D

func set_player(Player : KinematicBody2D):
	self.position = Player.position
	self.scale.x = Player.body.scale.x
	self.modulate = Player.body.modulate
	body_duplicator(self, Player.body)

func body_duplicator(Father : Node2D, duplicate_from : Node2D):
	for child in duplicate_from.get_children():
		if child is Polygon2D:
			var new_polygon : Polygon2D = Polygon2D.new()
			new_polygon.position = child.position
			new_polygon.offset = child.offset
			new_polygon.rotation = child.rotation
			new_polygon.polygon = child.polygon
			#new_polygon.name = child.name

			Father.add_child(new_polygon)
			body_duplicator(new_polygon, child)

func _ready():
	$Tween.interpolate_property(self, "modulate:a", 0.6, 0, 0.3)
	$Tween.start()

func _on_Tween_completed():
	self.call_deferred("free")
