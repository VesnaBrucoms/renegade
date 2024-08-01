extends Enemy

@export_category("Movement Pattern")
@export var enter_destination: Vector2
@export var shoot1_duration: float
@export var move_to1: Vector2
@export var shoot2_duration: float
@export var move_to2: Vector2
@export var shoot3_duration: float
@export var move_to3: Vector2

func _ready():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Shoot1.duration = shoot1_duration
	$MovementPattern/MovementActionToLocation.destination = move_to1
	$MovementPattern/Shoot2.duration = shoot2_duration
	$MovementPattern/MovementActionToLocation2.destination = move_to2
	$MovementPattern/Shoot3.duration = shoot3_duration
	$MovementPattern/MoveTo3.destination = move_to3
	$MovementPattern/Shoot1.set_duration()
	$MovementPattern/Shoot2.set_duration()
	$MovementPattern/Shoot3.set_duration()
	super._ready()
