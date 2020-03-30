extends Label

export(bool) var Autostart : bool = false
export(float) var Letter_Delay : float = 0.1

var text_to_print : String = ""
var character_num : int = 0

signal ended()

func _ready():
	text_to_print = self.text
	self.text = ""

	$letterSpeed.wait_time = Letter_Delay

	if Autostart:
		begin()

func begin() -> void:
	$letterSpeed.start()

func change_text(new_text : String) -> void:
	self.text = ""
	text_to_print = new_text
	character_num = 0
	begin()

func clear() -> void:
	self.text = ""
	character_num = 0
	$letterSpeed.stop()

func _on_letterSpeed_timeout():
	character_num += 1
	self.text = text_to_print.left(character_num)

	if character_num == text_to_print.length():
		$letterSpeed.stop()
		emit_signal("ended")
