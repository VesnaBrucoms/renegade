@tool
extends VisibleOnScreenNotifier2D

@export var tile_size: int ## Size, in pixels, of each tile in the level.

func _ready():
	if (get_parent()):
		var parent_tiles = get_parent().get_used_rect().size.y
		position.y = -((parent_tiles * tile_size) - 360)
