@tool
class_name Enemy extends Area2D

signal destroyed(intensity: float) ## Emitted when current_health reaches zero and enters DIEING state.

enum EnemyState { INACTIVE = 0, ENTERING = 1, SETUP = 2, ACTIVE = 3, RETIREMENT = 4, LEAVING = 5 }

@export var max_health: int ## Sets the maximum health.
@export var speed: float ## Sets the base top speed.
@export var hit_sound: AudioStream ## The audio stream to play when hit by player projectiles.
@export var death_camera_shake_intensity: float ## Sets how much to shake the camera on death.

@export_group("Debug")
@export var draw_indicators := true:
	set(value):
		draw_indicators = value
		notify_property_list_changed()
		queue_redraw()

var current_state: EnemyState
var current_health: int
var action_weapon_pairs: Dictionary

func _ready() -> void:
	if (Engine.is_editor_hint()):
		return
	
	current_state = EnemyState.INACTIVE
	current_health = max_health
	$HitSound.stream = hit_sound
	for child in get_children():
		if (child is Weapon):
			child.set_spawning_parent(get_parent())
			for action: String in child.actions_to_fire:
				action_weapon_pairs[action] = child
				var action_node: MovementAction = get_node("MovementPattern/" + action)
				child.cooldown_started.connect(action_node._entity_parent_weapon_cooldown_started)


func _process(_delta: float) -> void:
	if (Engine.is_editor_hint()):
		editor_update()
		queue_redraw()
	else:
		if (current_state > EnemyState.INACTIVE && $MovementPattern.current_state == $MovementPattern.MovementPatternState.READY):
			$MovementPattern.perform_next_action()


func _draw() -> void:
	if (!Engine.is_editor_hint()):
		return
	
	if (draw_indicators):
		var pattern_actions: Array[Node] = $MovementPattern.get_children()
		if (pattern_actions == null):
			return
		var tracked_position: Vector2 = Vector2.ZERO
		for action: MovementAction in pattern_actions:
			if (action is MovementActionToLocation):
				if (action.name == "Enter"):
					editor_draw_to_location_indicator(Vector2.ZERO, action.destination)
				else:
					editor_draw_to_location_indicator(tracked_position, action.destination)
				tracked_position = action.destination
			elif (action is MovementActionPath):
				tracked_position = editor_draw_path_indicator(tracked_position, action.destinations)
			elif (action is MovementActionWait):
				editor_draw_wait_indicator(tracked_position, action.duration)


func _movement_pattern_group_completed(group: MovementPattern.ActionGroup) -> void:
	if (group == MovementPattern.ActionGroup.ENTER):
		current_state = EnemyState.ACTIVE
		$MainSprite.visible = true
		$EnteringSprite.visible = false
		$EnteringRing.emitting = false


func _movement_pattern_action_started(action_name: String) -> void:
	if (action_name in action_weapon_pairs.keys()):
		if (current_state > EnemyState.INACTIVE):
			action_weapon_pairs.get(action_name).fire()
		else:
			action_weapon_pairs.get(action_name).stop()


func _area_entered(area: Area2D) -> void:
	if (Engine.is_editor_hint()):
		return
	
	if (current_state == EnemyState.ACTIVE):
		if (area is Projectile && area.is_player_weapon):
			current_health -= area.damage
			$HitSound.play_with_random_pitch()
			$HitSpray.emitting = true
			$MainSprite/HitFlashAnimation.play("hit_flash")
			area.destroy_projectile()
			if (current_health <= 0):
				$MainSprite.visible = false
				$DeathExplosion.visible = true
				$DeathExplosion/DeathAnimation.play("death")
				$DeathSpray.emitting = true
				$MovementPattern.force_stop()
				for weapon: Weapon in action_weapon_pairs.values():
					weapon.stop()
				emit_signal("destroyed", death_camera_shake_intensity)


func _visibility_notifier_screen_exited() -> void:
	if (current_state >= EnemyState.SETUP):
		queue_free()


func _death_spray_finished() -> void:
	queue_free()


## Called by activators or parents to change this enemy's state to be active.
func activate() -> void:
	if (current_state == EnemyState.INACTIVE):
		current_state = EnemyState.ENTERING
		# Activate $Invulnerability if not null
		$EnteringRing.emitting = true

############
## EDITOR
############

## Abstract method. EDITOR ONLY, to update any variables when changed in the inspector.
func editor_update() -> void:
	pass


## EDITOR ONLY, draws a movement indicator for a ToLocation MovementAction.
func editor_draw_to_location_indicator(start: Vector2, end: Vector2) -> void:
	var transformed_start: Vector2 = Vector2.ZERO
	if (start != Vector2.ZERO):
		transformed_start = editor_get_global_coords(start)
	var transformed_destination: Vector2 = editor_get_global_coords(end)
	editor_draw_movement_indicator(transformed_start, transformed_destination, Color.FOREST_GREEN)


## EDITOR ONLY, draws a series of movement indicators for a Path MovementAction. Returns the last destination.
func editor_draw_path_indicator(start: Vector2, points: Array[Vector2]) -> Vector2:
	var transformed_start: Vector2 = editor_get_global_coords(start)
	for destination in points:
		var transformed_destination: Vector2 = editor_get_global_coords(destination)
		editor_draw_movement_indicator(transformed_start, transformed_destination, Color.FIREBRICK)
		transformed_start = transformed_destination
	return transformed_start


## EDITOR ONLY, draws a wait indicator for a Wait MovementAction.
func editor_draw_wait_indicator(coords: Vector2, duration: float) -> void:
	var font: Font = preload("res://assets/fonts/kerxel.ttf")
	var transformed_coords: Vector2 = editor_get_global_coords(coords)
	draw_string(font, transformed_coords, "W " + str(duration), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.DODGER_BLUE)


## EDITOR ONLY, transforms the given co-ordinate to the global (level) co-ordinates.
func editor_get_global_coords(coords: Vector2) -> Vector2:
	return coords - global_position


## EDITOR ONLY, draws a movement indicator between the given points with a circle at the destination and in the given colour.
func editor_draw_movement_indicator(start: Vector2, end: Vector2, color: Color) -> void:
	draw_circle(end, 5.0, color)
	draw_line(start, end, color, 2.0)
