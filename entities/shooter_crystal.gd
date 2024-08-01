@tool
extends Enemy

@export_group("Movement Pattern")
@export_subgroup("Enter", "enter")
@export var enter_destination: Vector2
@export_subgroup("Active", "active")
@export var active_dart_centre: Vector2
@export var active_dart_radius: float

func _ready() -> void:
	if (!Engine.is_editor_hint()):
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		$MovementPattern.active_num_of_loops += rng.randi_range(0, 3)
	
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Dart.centre = active_dart_centre
	$MovementPattern/Dart.radius = active_dart_radius
	super._ready()
