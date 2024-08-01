class_name Weapon extends Node

signal cooldown_started ## Emitted when the weapon has finished firing all projectiles.
signal cooldown_finished ## Emitted when the cooldown timer has timed out.

enum WeaponState { READY = 0, FIRING = 1, FIRING_GAP = 2, COOLDOWN = 3 }

@export var cooldown: float ## In seconds, how long to wait between firing rounds.
@export var projectile: PackedScene ## Scene that defines the projectile to shoot.
@export var projectile_gap: float ## Seconds to wait between firing each set of projectiles in a round.
@export var fire_sound: AudioStream ## Sound file to play when firing.
@export var actions_to_fire: Array[String] ## Name(s) of the movement action(s) to fire this weapon.

var current_state: WeaponState
var projectile_count: int
var parent_level

func _ready() -> void:
	$CooldownTimer.wait_time = cooldown
	$GapTimer.wait_time = projectile_gap
	$FireSound.stream = fire_sound
	current_state = WeaponState.READY


func _cooldown_timer_timeout() -> void:
	current_state = WeaponState.READY
	projectile_count = 0
	$CooldownTimer.stop()
	emit_signal("cooldown_finished")


func _gap_timer_timeout() -> void:
	current_state = WeaponState.FIRING
	$GapTimer.stop()
	fire_round_part()


## Sets the node to spawn the projectiles onto. Usually the level or world.
func set_spawning_parent(parent) -> void:
	parent_level = parent


## Called by parent to fire.
func fire() -> void:
	if (current_state == WeaponState.READY):
		current_state = WeaponState.FIRING
		fire_round_part()


## Called by parent to stop firing during a firing round, e.g. when parent has died.
func stop() -> void:
	current_state = WeaponState.READY
	$GapTimer.stop()


## Abstract method. To be called in fire(), fires one "round" of projectiles.
func fire_round_part() -> void:
	pass


## Abstract method. Calculates the velocities of this round's projectiles.
func calculate_initial_velocities() -> Array[Vector2]:
	return []


## Spawns a projectile for each Vector2 velocity in the array.
func spawn_projectiles(initial_velocities: Array[Vector2]) -> void:
	if ($FireSound.stream):
		$FireSound.play_with_random_pitch()
	for velocity in initial_velocities:
		var new_projectile = projectile.instantiate()
		new_projectile.position = get_parent().position
		new_projectile.initial_velocity = velocity
		parent_level.add_child(new_projectile)
