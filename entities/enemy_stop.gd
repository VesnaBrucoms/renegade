extends "res://entities/enemy.gd"

@export_category("Movement Pattern")
@export var enter_destination: Vector2
@export var shoot_duration: float

func _ready():
	$MovementPattern/Enter.destination = enter_destination
	$MovementPattern/Shoot.duration = shoot_duration
	super._ready()
