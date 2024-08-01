extends Area2D

signal hit(intensity: float)
signal destroyed
signal shot(intensity: float)
signal dash_finished(intensity: float)

enum PlayerState { NORMAL = 0, DASHING = 1, DRAINED = 2, NO_CONTROL = 3}

@export var top_speed: float
@export var dash_speed: float
@export var drained_speed: float
@export var acceleration: float
@export var dash_acceleration: float
@export var max_health: int
@export var energy_cooldown: float

@export_group("Positioning")
@export var sprite_half_width: int
@export var sprite_half_height: int

var current_state: PlayerState
var screen_size
var size
var velocity: Vector2
var current_health: int
var player_dash: bool
var dash_locked_direction: Vector2

func _ready():
	current_state = PlayerState.NORMAL
	screen_size = get_viewport_rect().size
	size = $MainSprite.get_rect().size
	velocity = Vector2.ZERO
	current_health = max_health
	$WeaponStraight.set_spawning_parent(get_parent())


func _input(event: InputEvent):
	if (event.is_action_pressed("dash") && current_state == PlayerState.NORMAL):
		player_dash = true


func _process(delta):
	$WeaponSpray.emitting = false
	$DashFinishSpray.emitting = false
	var input_direction = get_input_direction()
	if (player_dash && input_direction != Vector2.ZERO && !Input.is_action_pressed("fire_primary")):
		current_state = PlayerState.DASHING
		player_dash = false
		dash_locked_direction = input_direction
		$DashTimer.start()
		$DashCollisionShape.disabled = false
		$DashSpray.emitting = true
	elif (player_dash && input_direction == Vector2.ZERO):
		player_dash = false
	
	if (current_state == PlayerState.DASHING):
		var t = dash_acceleration * delta
		velocity = velocity.lerp(dash_locked_direction * dash_speed, t)
	else:
		var current_speed
		if (current_state == PlayerState.NORMAL):
			current_speed = top_speed
		elif (current_state == PlayerState.DRAINED):
			current_speed = drained_speed
		
		var t = acceleration * delta
		if input_direction != Vector2.ZERO:
			velocity = velocity.lerp(input_direction * current_speed, t)
		else:
			velocity = velocity.lerp(Vector2.ZERO, t)
	
	position += velocity * delta
	position = clamp_position_to_screen(position)
	
	if (Input.is_action_pressed("fire_primary") && current_state != PlayerState.DASHING):
		$WeaponStraight.fire()
		$WeaponSpray.emitting = true
		emit_signal("shot", 1)


func _area_entered(area: Area2D):
	if (area is Projectile && !area.is_player_weapon):
		if (current_state == PlayerState.NORMAL || current_state == PlayerState.DRAINED):
			current_health -= area.damage
			$HitSound.play_with_random_pitch()
			area.destroy_projectile()
			if (current_health <= 0):
				queue_free()
				emit_signal("destroyed")
			else:
				emit_signal("hit", 2)
		elif (current_state == PlayerState.DASHING):
			area.destroy_projectile()


func _dash_timer_timeout():
	current_state = PlayerState.DRAINED
	velocity = Vector2.ZERO
	$DashSpray.emitting = false
	$DashCollisionShape.disabled = true
	$DashFinishSpray.emitting = true
	$MainSprite.visible = false
	$DrainedSprite.visible = true
	$DashTimer.stop()
	$DrainedTimer.start()
	emit_signal("dash_finished", 5)


func _drained_timer_timeout():
	current_state = PlayerState.NORMAL
	$MainSprite.visible = true
	$DrainedSprite.visible = false
	$DrainedTimer.stop()


## Gets the player input and returns the normalised movement direction.
func get_input_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	return direction.normalized()


## Adjusts the given position to fit within the screen bounds. Returns the adjusted Vector2.
func clamp_position_to_screen(new_position: Vector2) -> Vector2:
	var min_clamp_point = Vector2(sprite_half_width, sprite_half_height)
	var max_clamp_point = Vector2(screen_size.x - sprite_half_width, screen_size.y - sprite_half_height)
	return new_position.clamp(min_clamp_point, max_clamp_point)
