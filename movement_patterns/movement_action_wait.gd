class_name MovementActionWait extends MovementAction

@export_range(0.1, 5.0, 0.05, "or_greater", "hide_slider") var duration: float = 1 ## In seconds, the time to wait.

func _ready():
	$WaitTimer.wait_time = duration
	super._ready()


func _wait_timer_timeout():
	current_state = MovementActionState.COMPLETED
	$WaitTimer.stop()
	emit_signal("finished")


func set_duration():
	$WaitTimer.wait_time = duration


func perform():
	current_state = MovementActionState.PERFORMING
	$WaitTimer.start()
