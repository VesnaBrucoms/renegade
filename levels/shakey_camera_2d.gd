extends Camera2D

@export var shake_fade: float ## Sets how quickly should the camera shake fade.

var random: RandomNumberGenerator
var current_shake_intensity: float

func _ready():
	random = RandomNumberGenerator.new()


func _process(delta):
	if (current_shake_intensity > 0):
		current_shake_intensity = lerpf(current_shake_intensity, 0, shake_fade * delta)
	offset = get_random_offset()
	if (current_shake_intensity < 0.4):
		current_shake_intensity = 0


## Sets the intensity of the camera shake. Call this to start the camera shaking.
func set_shake_intensity(intensity: float) -> void:
	if (intensity > current_shake_intensity):
		current_shake_intensity = intensity


## Returns a new Vector2 with random values generated from the current_shake_intensity.
func get_random_offset() -> Vector2:
	return Vector2(random.randf_range(-current_shake_intensity, current_shake_intensity), random.randf_range(-current_shake_intensity, current_shake_intensity))
