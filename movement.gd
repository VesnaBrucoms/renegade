class_name Movement extends Node

const DISTANCE_MARGIN := 3.0 ## The number of pixels to be at or below for distance checks.

var destination: Vector2
var speed: float
var velocity: Vector2

func set_destination(new_destination: Vector2) -> void:
	destination = new_destination


func set_speed(new_speed: float) -> void:
	speed = new_speed


func reached_destination(current_position: Vector2) -> bool:
	return current_position.distance_to(destination) <= DISTANCE_MARGIN


## Calculate the current frame's distance travelled towards the destination. Returns the change in position.
func move_to_destination(delta: float, current_position: Vector2) -> Vector2:
	print(destination)
	var direction: Vector2 = current_position.direction_to(destination)
	velocity = direction * speed
	return velocity * delta


## Calculate the current frame's distance travelled towards the destination, with applied acceleration and decelleration.  Returns the change in position.
func accelerate_to_destination(delta: float, current_position: Vector2, acceleration: float = 0.0) -> Vector2:
	var direction: Vector2 = current_position.direction_to(destination)
	velocity = velocity.lerp(direction * speed, delta * acceleration)
	return velocity * delta
