class_name MovementActionPath extends MovementAction

@export var destinations: Array[Vector2] ## Coordinates' to move to.
@export var override_speed: float ## If set to something other than 0.0, will use this as the entity's speed.
@export var face_direction: bool ## If true, rotates the entity parent to face the moving direction. NOTE: Godot considers 0 degrees to be Vector2.RIGHT.
@export var use_acceleration: bool ## If true, smooths the acceleration and movement between points.
@export var acceleration: float ## How quickly to accelerate.

var speed: float
var velocity: Vector2
var next_destination: int

func _process(delta):
	if (current_state == MovementActionState.PERFORMING):
		if (entity_parent.position.distance_to(destinations[next_destination]) <= 3.0):
			next_destination += 1
			if (next_destination == destinations.size()):
				next_destination = 0
				velocity = Vector2.ZERO
				current_state = MovementActionState.COMPLETED
				emit_signal("finished")
		else:
			var direction = entity_parent.position.direction_to(destinations[next_destination])
			if (use_acceleration):
				velocity = velocity.lerp(direction * speed, delta * acceleration)
			else:
				velocity = direction * speed
			entity_parent.position += velocity * delta
			if (face_direction):
				entity_parent.rotation = direction.angle()


func perform():
	if (override_speed > 0.0):
		speed = override_speed
	else:
		speed = entity_parent.speed
	current_state = MovementActionState.PERFORMING
