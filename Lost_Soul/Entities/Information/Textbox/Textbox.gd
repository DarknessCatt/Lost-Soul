extends Label

export(bool) var Autocenter : bool = false
export(bool) var Autostart : bool = false
export(float) var Letter_Delay : float = 0.1
export(float) var Sentence_Delay : float = 1
export(Array, String, MULTILINE) var dialogue : Array = []

var text_to_print : int = 0
var character_num : int = 0

var original_position : Vector2 = Vector2(0,0)

signal ended()

func _ready():
	original_position = self.rect_position

	text_to_print = 0
	self.text = ""

	$letterSpeed.wait_time = Letter_Delay
	$sentenceSpeed.wait_time = Sentence_Delay

	if Autostart:
		begin()

func begin() -> void:
	$letterSpeed.start()

func change_dialogue(new_dial : Array) -> void:
	dialogue = new_dial
	character_num = 0
	self.clear()

func clear() -> void:
	self.text = ""
	text_to_print = 0
	character_num = 0
	$letterSpeed.stop()
	$sentenceSpeed.stop()
	if Autocenter:
		self.rect_size = Vector2(0,0)

func _on_letterSpeed_timeout():
	character_num += 1
	self.text = dialogue[text_to_print].left(character_num)

	if Autocenter:
		self.rect_position = -(self.rect_size*self.rect_scale)/2 + self.original_position

	if character_num == dialogue[text_to_print].length():
		text_to_print += 1
		$letterSpeed.stop()

		if text_to_print == dialogue.size():
			emit_signal("ended")

		else:
			$sentenceSpeed.start()

func _on_sentenceSpeed_timeout():
	character_num = 0
	$letterSpeed.start()
