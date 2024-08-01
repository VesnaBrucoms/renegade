extends "res://weapons/weapon.gd"

@export var size_of_arc: int ## In degrees the width of the arc.
@export var direction: Vector2 ## Direction the arc is pointed at.
@export var num_of_shots: int ## Number of projectiles in an arc.
@export var num_of_projectiles: int ## The number of projectiles to fire before cooldown.

func fire_round_part() -> void:
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
	var delta = deg_to_rad(size_of_arc / num_of_shots)
	for point in num_of_shots:
		velocities.append(direction.rotated(delta * point))
	return velocities
