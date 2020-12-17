tool
extends Polygon2D

enum TYPES {SKY, CLOUD, BG_ROCK, HARD_ROCK, SOFT_ROCK, GRASS, LEAVE}

export(TYPES) var type : int = TYPES.SKY setget change_type

func change_type(new_type):
	if Engine.editor_hint:
		match(new_type):
			TYPES.SKY:
				self.color = Color("82a2af")

			TYPES.CLOUD:
				self.color = Color("a0bcc8")

			TYPES.BG_ROCK:
				self.color = Color("2c2221")

			TYPES.HARD_ROCK:
				self.color = Color("443a38")

			TYPES.SOFT_ROCK:
				self.color = Color("5d524e")

			TYPES.GRASS:
				self.color = Color("8e831a")

			TYPES.LEAVE:
				self.color = Color("736a0f")

	type = new_type
