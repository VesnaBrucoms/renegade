@tool
extends "res://weapons/weapon.gd"

@export var circle_size: int ## Number of projectiles in a given circle.
@export var num_of_circles: int ## Number of circles to fire.
@export var stagger_circles := false: ## Shift each circle from the previous.
	set(value):
		stagger_circles = value
		notify_property_list_changed()
@export var stagger_amount: float ## Amount to stagger circles by.

## EDITOR ONLY
func _validate_property(property: Dictionary):
	if property.name in ["stagger_amount"] and not stagger_circles:
		property.usage = PROPERTY_USAGE_READ_ONLY


func fire_round_part() -> void:
	spawn_projectiles(calculate_initial_velocities())
	projectile_count += 1
	if (projectile_count < num_of_circles):
		current_state = WeaponState.FIRING_GAP
		$GapTimer.start()
	else:
		current_state = WeaponState.COOLDOWN
		$CooldownTimer.start()
		emit_signal("cooldown_started")


func calculate_initial_velocities() -> Array[Vector2]:
	var velocities: Array[Vector2] = []
	var delta = deg_to_rad(360 / circle_size)
	var stagger = stagger_amount * projectile_count
	for point in circle_size:
		if (stagger_circles):
			velocities.append(Vector2.RIGHT.rotated((delta * point) + stagger))
		else:
			velocities.append(Vector2.RIGHT.rotated(delta * point))
	return velocities
