@tool
extends Enemy

@export_category("Movement Pattern")
@export_group("Enter")
@export var enter_destination: Vector2
@export var enter_speed: float
@export var enter_acceleration: float

@export_group("Path")
@export var path_destinations: Array[Vector2]
@export var path_speed: float
@export var path_face_direction: bool
@export var path_acceleration: float

func _ready():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Enter.override_speed = enter_speed
	if (enter_acceleration > 0.0):
		$MovementPattern/Enter.use_acceleration = true
		$MovementPattern/Enter.acceleration = enter_acceleration
	
	$MovementPattern/Path.destinations = path_destinations
	$MovementPattern/Path.override_speed = path_speed
	$MovementPattern/Path.face_direction = path_face_direction
	if (path_acceleration > 0.0):
		$MovementPattern/Path.use_acceleration = true
		$MovementPattern/Path.acceleration = path_acceleration
	super._ready()


func editor_update():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Path.destinations = path_destinations
