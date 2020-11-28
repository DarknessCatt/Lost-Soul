extends Node2D

export(PackedScene) var bullet_res : PackedScene

#Flags
var show_dropdown : bool = true
var show_altar : bool = true
var altar_dialogue : bool = true

func _on_Souls_entered(_body):
	$Player/Hero.cutscene = $Player/Hero.cutscene_type.PHYSICS
	$Objects/Dialogues/Souls.begin_dialogue()

func _on_Souls_dialogue_end():
	$Player/Hero.cutscene = $Player/Hero.cutscene_type.NONE

func _on_Drop_Down_entered(_body):
	if show_dropdown:
		$Objects/Tutorials/Drop_Down/Tween.stop_all()
		$Objects/Tutorials/Drop_Down/Tween.interpolate_property(
				$Objects/Tutorials/Drop_Down/Arrow, "modulate:a",
				$Objects/Tutorials/Drop_Down/Arrow.modulate.a, 1, 0.5)
		$Objects/Tutorials/Drop_Down/Tween.start()

func _on_Drop_Down_exited(_body):
	$Objects/Tutorials/Drop_Down/Tween.stop_all()
	$Objects/Tutorials/Drop_Down/Tween.interpolate_property(
			$Objects/Tutorials/Drop_Down/Arrow, "modulate:a",
			$Objects/Tutorials/Drop_Down/Arrow.modulate.a, 0, 0.5)
	$Objects/Tutorials/Drop_Down/Tween.start()

func _on_Altar_Area_entered(_body):
	$Objects/Altar_Area/Altar_Camera.current = true

func _on_Altar_Area_exited(_body):
	$Player/Hero/Camera2D.current = true

func _on_Altar_entered(_body):
	if altar_dialogue:
		altar_dialogue = false
		$Objects/Dialogues/Altar.begin_dialogue()
		$Player/Hero.cutscene = $Player/Hero.cutscene_type.PHYSICS

	if show_altar:
		$Objects/Altar_Area/Tween.stop_all()
		$Objects/Altar_Area/Tween.interpolate_property($Objects/Altar_Area/Arrow,
				"modulate:a", $Objects/Altar_Area/Arrow.modulate.a, 1, 0.5)
		$Objects/Altar_Area/Tween.start()

func _on_Altar_dialogue_end():
	$Player/Hero.cutscene = $Player/Hero.cutscene_type.NONE

func _on_Altar_exited(_body):
	if show_altar:
		$Objects/Altar_Area/Tween.stop_all()
		$Objects/Altar_Area/Tween.interpolate_property($Objects/Altar_Area/Arrow,
				"modulate:a", $Objects/Altar_Area/Arrow.modulate.a, 0, 0.5)
		$Objects/Altar_Area/Tween.start()

func _on_checkpoint_activated(_checkpoint_menu):
	$Player/Hero.cutscene = $Player/Hero.cutscene_type.PHYSICS

	$Menu/Upgrade_Menu/Menu/Soul_Node/Souls.text = str($Player/Hero.souls)
	if $Player/Hero.souls < 5: $Menu/Upgrade_Menu/Menu/Upgrades/Upgrade.disabled = true
	else: $Menu/Upgrade_Menu/Menu/Upgrades/Upgrade.disabled = false

	$Menu/Tween.stop_all()
	$Menu/Tween.interpolate_property($Menu/Upgrade_Menu, "modulate:a", 0, 1, 0.5)
	$Menu/Tween.start()

func _on_Back_pressed():
	$Player/Hero.cutscene = $Player/Hero.cutscene_type.NONE
	$Menu/Tween.stop_all()
	$Menu/Tween.interpolate_property($Menu/Upgrade_Menu, "modulate:a", 1, 0, 0.5)
	$Menu/Tween.start()

func _on_Upgrade_pressed():
	self._on_Back_pressed()

	$Player/Hero.souls -= 5
	$Menu/Upgrade_Menu/Menu/Cost/Valor.text = "-"

	$Objects/Tutorials/Attack.disabled = false

	if show_altar:
		$Objects/Altar_Area/Tween.stop_all()
		$Objects/Altar_Area/Tween.interpolate_property($Objects/Altar_Area/Arrow,
				"modulate:a", $Objects/Altar_Area/Arrow.modulate.a, 0, 0.5)
		$Objects/Altar_Area/Tween.start()

	show_altar = false
	show_dropdown = false

func _on_Dir_Attacks_entered(_body):
	$Objects/Tutorials/Dir_Attacks/Tween2.stop_all()
	$Objects/Tutorials/Dir_Attacks/Tween2.interpolate_property(
			$Objects/Tutorials/Dir_Attacks/Arrow, "modulate:a",
			$Objects/Tutorials/Dir_Attacks/Arrow.modulate.a, 1, 0.5)
	$Objects/Tutorials/Dir_Attacks/Tween2.start()

func _on_Dir_Attacks_exited(_body):
	$Objects/Tutorials/Dir_Attacks/Tween2.stop_all()
	$Objects/Tutorials/Dir_Attacks/Tween2.interpolate_property(
			$Objects/Tutorials/Dir_Attacks/Arrow, "modulate:a",
			$Objects/Tutorials/Dir_Attacks/Arrow.modulate.a, 0, 0.5)
	$Objects/Tutorials/Dir_Attacks/Tween2.start()

func _on_Bullet_Trigger_body_entered(_body):
	$Objects/Tutorials/Bullet/Tutorial_Action/area.call_deferred("set", "disabled", false)

	$Player/Hero.health = $Player/Hero.max_health
	$Player/Hero.energy = $Player/Hero.max_energy
	$Player/Hero.invencible = false
	var new_bullet = bullet_res.instance()
	new_bullet.rotation = 3.14
	new_bullet.SPEED = 1500
	new_bullet.global_position = $Objects/Tutorials/Bullet.global_position
	self.call_deferred("add_child", new_bullet)
