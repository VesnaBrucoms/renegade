class_name MovementActionWithinArea extends MovementAction

@export var centre: Vector2 ## Co-ordinates of the centre of the area within to move.
@export_range(6.0, 200, 0.5, "or_greater", "suffix:px") var radius: float ## Defines the size of the area.

@export_group("Translation")
@export var override_speed: float ## If set to something other than 0.0, will use this as the entity's speed.
@export var use_acceleration: bool ## If true, smooths the acceleration and movement between points.
@export var acceleration: float ## How quickly to accelerate.

var movement: Movement

func _ready() -> void:
	super._ready()
	movement = Movement.new()


func _process(delta: float) -> void:
	if (current_state == MovementActionState.PERFORMING):
		if (movement.reached_destination(entity_parent.position)):
			current_state = MovementActionState.COMPLETED
			emit_signal("finished")
		else:
			if (use_acceleration):
				entity_parent.position += movement.accelerate_to_destination(delta, entity_parent.position, acceleration)
			else:
				entity_parent.position += movement.move_to_destination(delta, entity_parent.position)


func perform() -> void:
	if (override_speed > 0.0):
		movement.set_speed(override_speed)
	else:
		movement.set_speed(entity_parent.speed)
	movement.set_destination(select_destination())
	current_state = MovementActionState.PERFORMING


## Selects a random co-ordinate within the centre co-ordinate +/- radius.
func select_destination() -> Vector2:
	var new_dest: Vector2 = generate_random_destination()
	
	if (new_dest.distance_to(entity_parent.position) <= DISTANCE_MARGIN * 2):
		new_dest.x += 6.0
		new_dest.y += 6.0
	return new_dest


func generate_random_destination() -> Vector2:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var x_pos: float = rng.randf_range(centre.x - radius, centre.x + radius)
	var y_pos: float = rng.randf_range(centre.y - radius, centre.y + radius)
	return Vector2(x_pos, y_pos)
