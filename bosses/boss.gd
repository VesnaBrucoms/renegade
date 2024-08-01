class_name Boss extends Area2D

signal dialogue_started(lines: Array[DialogueLine]) ## Emitted when the entry movement is completed.
signal activated() ## Emitted when entered into ACTIVE state.
signal trembeled(intensity: float) ## Emitted when an action or weapon causes significant camera shake.
signal destroyed(intensity: float) ## Emitted when current_health reaches zero and enters DIEING state.

enum BossState { INACTIVE = 0, INTRO = 1, INTRO_DIALOGUE = 2, ACTIVE = 3, DIEING = 4 }

@export var max_health: int ## Sets the maximum health.
@export var speed: float ## Sets the base top speed.
@export var death_camera_shake_intensity: float ## Sets how much to shake the camera on death.

var current_state: BossState
var current_health: int
var action_weapon_pairs: Dictionary

func _ready():
	current_state = BossState.INACTIVE
	current_health = max_health
	for child in get_children():
		if (child is Weapon):
			child.set_spawning_parent(get_parent())
			for action in child.actions_to_fire:
				action_weapon_pairs[action] = child


func _process(_delta):
	if (current_state >= BossState.INTRO):
		$MovementPattern.perform_next_action()


func _level_screen_entered() -> void:
	current_state = BossState.INTRO
	$EnteringRing.emitting = true


func _intro_movement_pattern_pattern_completed(group: MovementPattern.ActionGroup) -> void:
	if (group == MovementPattern.ActionGroup.ENTER):
		current_state = BossState.INTRO_DIALOGUE
		emit_signal("dialogue_started", $DialogueIntro.lines)


func _dialogue_completed() -> void:
	current_state = BossState.ACTIVE
	$Sprite2D.visible = true
	$EnteringSprite.visible = false
	$EnteringRing.emitting = false
	emit_signal("activated")


func _area_entered(area: Area2D) -> void:
	if (Engine.is_editor_hint()):
		return
	
	if (current_state == BossState.ACTIVE):
		if (area is Projectile && area.is_player_weapon):
			current_health -= area.damage
			$HitSound.play_with_random_pitch()
			$HitSpray.emitting = true
			$Sprite2D/HitFlashAnimation.play("hit_flash")
			area.destroy_projectile()
			if (current_health <= 0):
				current_state = BossState.DIEING
				emit_signal("destroyed", death_camera_shake_intensity)
				emit_signal("dialogue_started", $DialogueOutro.lines)
				queue_free()


func _movement_pattern_action_started(action_name: String) -> void:
	if (action_name in action_weapon_pairs.keys()):
		action_weapon_pairs.get(action_name).fire()
