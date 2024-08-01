@tool
extends Node2D

enum LevelState { INTRO = 0, INTRO_TRANSITION = 1, PLAYING = 2, BOSS_INTRO = 3, BOSS = 4, OUTRO = 5, PAUSED = 6 }

@export var scroll_intro_speed: float
@export var scroll_speed: float

@export_group("Debug")
@export var draw_indicators := true:
	set(value):
		draw_indicators = value
		notify_property_list_changed()
		queue_redraw()

var current_state: LevelState
var scroll_direction: Vector2
var boss: Boss

func _ready():
	if (Engine.is_editor_hint()):
		return
	
	current_state = LevelState.INTRO
	scroll_direction = Vector2(0.0, 1.0)
	for child in get_children():
		if (child is Enemy):
			child.destroyed.connect(_shake_camera)
		elif (child is Boss):
			boss = child
			child.dialogue_started.connect($DialogueManager._dialogue_started)
			child.activated.connect(_boss_activated, CONNECT_ONE_SHOT)
			child.destroyed.connect(_shake_camera)
			child.destroyed.connect(_boss_destroyed)
			$TileMap/LevelTopNotifier.screen_entered.connect(child._level_screen_entered, CONNECT_ONE_SHOT)
		elif (child is DialogueManager):
			child.completed.connect(_dialogue_manager_completed)
		elif (child is Intro):
			child.dialogue_started.connect($DialogueManager._dialogue_started)


func _process(delta):
	if (Engine.is_editor_hint()):
		return

	if (current_state == LevelState.INTRO_TRANSITION):
		scroll_tile_map(scroll_intro_speed, delta)
	elif (current_state == LevelState.PLAYING):
		scroll_tile_map(scroll_speed, delta)


func _draw():
	if (!Engine.is_editor_hint()):
		return
	if (draw_indicators):
		var tile_count = $TileMap.get_used_rect().size.y
		var pixel_height = tile_count * 16
		var full_camera_shots = pixel_height / 360
		for cam in full_camera_shots:
			var rect = Rect2(Vector2(0, -360 * cam), Vector2(640, 360))
			draw_rect(rect, Color.BLUE_VIOLET, false, 2.0)


func _shake_camera(intensity: float) -> void:
	$ShakeyCamera2D.set_shake_intensity(intensity)


func _dialogue_manager_completed() -> void:
	if (current_state == LevelState.INTRO):
		current_state = LevelState.INTRO_TRANSITION
		$Intro.start_transition()
	elif (current_state == LevelState.BOSS_INTRO):
		current_state = LevelState.BOSS
		boss._dialogue_completed()


func _level_screen_1_notifier_screen_entered() -> void:
	current_state = LevelState.PLAYING


func _level_top_notifier_screen_entered() -> void:
	current_state = LevelState.BOSS_INTRO


func _boss_activated() -> void:
	current_state = LevelState.BOSS


func _boss_destroyed() -> void:
	current_state = LevelState.OUTRO


## Updates the TileMap's position at the passed speed.
func scroll_tile_map(speed: float, delta: float) -> void:
	var scroll_velocity = scroll_direction * speed
	$TileMap.position += scroll_velocity * delta
