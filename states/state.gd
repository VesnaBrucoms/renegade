class_name State extends Node

signal state_pushed(new_state: String)
signal state_popped(new_state: String)
signal state_replaced(new_state: String)

@export var unique_name: String


## Set the state's children to is_visible.
func set_visibility(is_visible: bool) -> void:
	for child in get_children():
		child.visible = is_visible


## Called when the state is back to being the current_state in the manager.
func enter() -> void:
	pass
