@tool
extends Enemy

@export_category("Movement Pattern")
@export_group("Enter")
@export var enter_destination: Vector2
@export var enter_speed: float
@export var enter_acceleration: float

@export_group("Shoot1")
@export var shoot1_duration: float

@export_group("Move1")
@export var move1_destination: Vector2
@export var move1_speed: float
@export var move1_acceleration: float

@export_group("Shoot2")
@export var shoot2_duration: float

@export_group("Move2")
@export var move2_destination: Vector2
@export var move2_speed: float
@export var move2_acceleration: float

@export_group("Shoot3")
@export var shoot3_duration: float

@export_group("Exit")
@export var exit_destination: Vector2
@export var exit_speed: float
@export var exit_acceleration: float

func _ready():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Enter.override_speed = enter_speed
	if (enter_acceleration > 0.0):
		$MovementPattern/Enter.use_acceleration = true
		$MovementPattern/Enter.acceleration = enter_acceleration
	
	$MovementPattern/Shoot1.duration = shoot1_duration
	$MovementPattern/Shoot1.set_duration()
	
	$MovementPattern/Move1.destination = move1_destination
	$MovementPattern/Move1.override_speed = move1_speed
	if (move1_acceleration > 0.0):
		$MovementPattern/Move1.use_acceleration = true
		$MovementPattern/Move1.acceleration = move1_acceleration
	
	$MovementPattern/Shoot2.duration = shoot2_duration
	$MovementPattern/Shoot2.set_duration()
	
	$MovementPattern/Move2.destination = move2_destination
	$MovementPattern/Move2.override_speed = move2_speed
	if (move2_acceleration > 0.0):
		$MovementPattern/Move2.use_acceleration = true
		$MovementPattern/Move2.acceleration = move2_acceleration
	
	$MovementPattern/Shoot3.duration = shoot3_duration
	$MovementPattern/Shoot3.set_duration()
	
	$MovementPattern/Exit.destination = exit_destination
	$MovementPattern/Exit.override_speed = exit_speed
	if (exit_acceleration > 0.0):
		$MovementPattern/Exit.use_acceleration = true
		$MovementPattern/Exit.acceleration = exit_acceleration
	super._ready()


func editor_update():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Move1.destination = move1_destination
	$MovementPattern/Move2.destination = move2_destination
	$MovementPattern/Exit.destination = exit_destination
