class_name MovementAction extends Node

signal finished ## Emitted when the action has reached its defined end point.

enum MovementActionState { READY = 0, PERFORMING = 1, COMPLETED = 2 }

const DISTANCE_MARGIN := 3.0 ## The number of pixels to be at or below for distance checks.

@export var action_group: MovementPattern.ActionGroup

var current_state: MovementActionState
var entity_parent

func _ready() -> void:
	current_state = MovementActionState.READY


## Abstract method. Callback for any weapon that finished firing during the performing of this action.
func _entity_parent_weapon_cooldown_started() -> void:
	pass


## Sets the ultimate entity parent this action belongs to. The pattern's parent.
func set_parent(parent) -> void:
	entity_parent = parent


## Abstract method. Engages this action.
func perform() -> void:
	pass


## Stops the action.
func force_stop() -> void:
	current_state = MovementActionState.COMPLETED
