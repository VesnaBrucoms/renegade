class_name MovementActionToLocation extends MovementAction

@export var destination: Vector2 ## Coordinates to move to.

@export_group("Translation")
@export var override_speed: float ## If set to something other than 0.0, will use this as the entity's speed.
@export var use_acceleration: bool ## If true, smooths the acceleration and movement between points.
@export var acceleration: float ## How quickly to accelerate.

var move: Movement

func _ready() -> void:
	super._ready()
	move = Movement.new()
	move.set_destination(destination)

func _process(delta: float) -> void:
	if (current_state == MovementActionState.PERFORMING):
		if (move.reached_destination(entity_parent.position)):
			current_state = MovementActionState.COMPLETED
			emit_signal("finished")
		else:
			if (use_acceleration):
				entity_parent.position += move.accelerate_to_destination(delta, entity_parent.position, acceleration)
			else:
				entity_parent.position += move.move_to_destination(delta, entity_parent.position)


func perform() -> void:
	if (override_speed > 0.0):
		move.set_speed(override_speed)
	else:
		move.set_speed(entity_parent.speed)
	current_state = MovementActionState.PERFORMING
