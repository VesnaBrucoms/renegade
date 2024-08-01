extends "res://weapons/weapon.gd"

@export var delta: float ## In degrees the amount each subsequant projectile is shifted in the wave.
@export var max_delta: float ## In radians, the maximum shift in direction the wave reaches before reversing.
@export var direction: Vector2 ## Direction the wave is pointed at.
@export var num_of_projectiles: int ## The number of projectiles to fire before cooldown.

var total_delta: float
var is_reversing: bool

func fire_round_part() -> void:
	if (projectile_count == 0):
		total_delta = 0
	spawn_projectiles(calculate_initial_velocities())
	projectile_count += 1
	if (projectile_count < num_of_projectiles):
		current_state = WeaponState.FIRING_GAP
		$GapTimer.start()
	else:
		current_state = WeaponState.COOLDOWN
		$CooldownTimer.start()
		emit_signal("cooldown_started")


func calculate_initial_velocities() -> Array[Vector2]:
	var velocities: Array[Vector2] = []
	if (is_reversing):
		total_delta -= deg_to_rad(delta)
	else:
		total_delta += deg_to_rad(delta)
	velocities.append(direction.rotated(total_delta))
	if (total_delta >= max_delta):
		is_reversing = true
	elif (total_delta <= 0):
		is_reversing = false
	return velocities
