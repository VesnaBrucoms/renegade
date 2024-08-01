extends "res://weapons/weapon.gd"

@export var num_of_projectiles: int ## The number of projectiles to fire before cooldown.
@export var shoot_up: bool ## Should the weapon shoot in the up direction.
@export var shoot_right: bool ## Should the weapon shoot in the right direction.
@export var shoot_down: bool ## Should the weapon shoot in the down direction.
@export var shoot_left: bool ## Should the weapon shoot in the left direction.

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
	if (shoot_up):
		velocities.append(Vector2(0, -1))
	if (shoot_right):
		velocities.append(Vector2(1, 0))
	if (shoot_down):
		velocities.append(Vector2(0, 1))
	if (shoot_left):
		velocities.append(Vector2(-1, 0))
	return velocities
