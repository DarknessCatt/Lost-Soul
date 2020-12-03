extends Control

signal menu_exited()

const HP_INC : int = 20
const SP_INC : int = 15

var hero : KinematicBody2D = null
var souls : int = 0 setget set_souls
var cost : int = 0

func set_souls(value : int) -> void:
	souls = value
	$Menu/Soul_Node/Souls.text = str(souls)

func _ready():
	assert(hero != null)
	self.souls = hero.souls
	calculate_cost()

func calculate_cost() -> void:
	cost = hero.level*5 + int(hero.level*hero.level*0.5)
	$Menu/Upgrades/Cost/Valor.text = str(cost)

	if cost <= souls:
		$Menu/Upgrades/Cost.modulate = Color(1,1,1,1)

	else:
		$Menu/Upgrades/Cost.modulate = Color(1,0,0,1)
		$Menu/Upgrades/HP.disabled = true
		$Menu/Upgrades/SP.disabled = true

func _on_HP_pressed():
	if souls >= cost:
		hero.level += 1
		hero.health += HP_INC
		hero.max_health += HP_INC
		self.souls -= cost
		calculate_cost()

func _on_SP_pressed():
	if souls >= cost:
		hero.level += 1
		hero.energy += SP_INC
		hero.max_energy += SP_INC
		self.souls -= cost
		calculate_cost()

func _on_Back_pressed():
	emit_signal("menu_exited")
	hero.souls = self.souls
