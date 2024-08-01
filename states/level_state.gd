extends State

@export var loaded_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_level = loaded_level.instantiate()
	add_child(current_level)
