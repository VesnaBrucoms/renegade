@tool
class_name MovementActionToZone extends MovementAction

const LEFT_ZONE := Rect2(Vector2(0, 0), Vector2(213, 180))
const CENTRE_ZONE := Rect2(Vector2(213, 0), Vector2(213, 180))
const RIGHT_ZONE := Rect2(Vector2(426, 0), Vector2(213, 180))

@export_enum("Left", "Centre", "Right", "Custom") var zone:= 0: ## Select from predetermined zones, or create a custom zone.
	set(value):
		zone = value
		notify_property_list_changed()
@export var custom_zone: Rect2 ## Space on the screen to randomly select a movement destination. Position is the top-left corner.

@export_group("Translation")
@export var override_speed: float ## If set to something other than 0.0, will use this as the entity's speed.
@export var use_acceleration: bool ## If true, smooths the acceleration and movement between points.
@export var acceleration: float ## How quickly to accelerate.

var chosen_zone: Rect2 ## The final Rect2 zone selected.
var destination: Vector2 ## Coordinates to move to.
var speed: float ## Top speed to move towards the destination.
var velocity: Vector2 ## Current velocity.

func _ready() -> void:
	super._ready()
	chosen_zone = set_chosen_zone()


func _process(delta: float) -> void:
	if (current_state == MovementActionState.PERFORMING):
		if (entity_parent.position.distance_to(destination) <= 3.0):
			current_state = MovementActionState.COMPLETED
			emit_signal("finished")
		else:
			velocity = move_to_destination(destination, speed, velocity, use_acceleration, acceleration)


func perform() -> void:
	if (override_speed > 0.0):
		speed = override_speed
	else:
		speed = entity_parent.speed
	select_destination()
	current_state = MovementActionState.PERFORMING


## Determines which Rect2 to use as this action's zone.
func set_chosen_zone() -> Rect2:
	var chosen: Rect2
	if (zone == 0):
		chosen = LEFT_ZONE
	elif (zone == 1):
		chosen = CENTRE_ZONE
	elif (zone == 2):
		chosen = RIGHT_ZONE
	elif (zone == 3):
		chosen = custom_zone
	return chosen


## Selects a random co-ordinate within the centre co-ordinate +/- radius.
func select_destination() -> void:
	var rng = RandomNumberGenerator.new()
	var x_pos: float = rng.randf_range(chosen_zone.position.x, chosen_zone.end.x)
	var y_pos: float = rng.randf_range(chosen_zone.position.y, chosen_zone.end.y)
	destination = Vector2(x_pos, y_pos)

############
## EDITOR
############

func _validate_property(property: Dictionary):
	if (property.name in ["custom_zone"] and zone != 3):
		property.usage = PROPERTY_USAGE_READ_ONLY
