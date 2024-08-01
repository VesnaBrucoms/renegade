class_name Intro extends Node2D

signal dialogue_started ## Emitted when the load delay timer times out.

enum IntroState { DELAY = 0, DIALOGUE = 1, TRANSITION = 2 }

var current_state: IntroState ## Current IntroState.

func _ready():
	current_state = IntroState.DELAY
	for child in get_children():
		if (child is DialogueLine):
			$Dialogue.lines.append(child)
	$LoadDelayTimer.start()


func _load_delay_timer_timeout() -> void:
	current_state = IntroState.DIALOGUE
	$LoadDelayTimer.stop()
	emit_signal("dialogue_started", $Dialogue.lines)


func start_transition() -> void:
	current_state = IntroState.TRANSITION
	$Clouds1/ReduceDensity.play("reduce_density")
	$Clouds2/ReduceDensity.play("reduce_density_2")
