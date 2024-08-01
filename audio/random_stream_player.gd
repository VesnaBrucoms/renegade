extends AudioStreamPlayer

@export var lowest_pitch: float = 0.95 ## The lowest pitch to randomly set it to.
@export var highest_pitch: float = 1.05 ## The highest pitch to randomly set it to.

var rng: RandomNumberGenerator ## Random number generator for getting random floats.

func _ready():
	rng = RandomNumberGenerator.new()


## Plays the audio from the given from_position, in seconds. Randomises the pitch scale each time it's called.
func play_with_random_pitch(from_position: float = 0.0) -> void:
	pitch_scale = rng.randf_range(lowest_pitch, highest_pitch)
	play(from_position)
