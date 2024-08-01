class_name MovementActionWaitFor extends MovementAction

func _entity_parent_weapon_cooldown_started() -> void:
	current_state = MovementActionState.COMPLETED
	emit_signal("finished")


func perform() -> void:
	current_state = MovementActionState.PERFORMING
