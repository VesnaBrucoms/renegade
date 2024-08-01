## Handles performing of MovementActions by their groups.
##
## MovementAction child nodes are executed by ActionGroup group they are in and in the order in which they are in the SceneTree.
class_name MovementPattern extends Node

signal action_started(action_name: String) ## Emitted when the next action starts. Passes the action's unique name.
signal action_finished(action_name: String) ## Emitted when the current action finishes. Passes the action's unique name.
signal group_repeated(group: ActionGroup) ## Emitted when a repeating group resets.
signal group_finished(group: ActionGroup) ## Emitted when all actions in a group are completed. If looping only emits once the set number of loops are done.

enum MovementPatternState { READY = 0, PERFORMING_ACTION = 1, COMPLETED = 2 }
enum ActionGroup { ENTER = 0, SETUP = 1, ACTIVE = 2, RETIREMENT = 3, LEAVE = 4 }

@export_group("Action Groups")
@export_subgroup("Active", "active")
@export var active_repeatable: bool ## Set to "TRUE" to loop all ACTIVE actions.
@export_range(0, 30) var active_num_of_loops: int ## Number of times to loop through the action group. Set to 0 to infinitely loop.

@export_subgroup("Retirement", "retirement")
@export var retirement_repeatable: bool ## Set to "TRUE" to loop all RETIREMENT actions.
@export_range(0, 30) var retirement_num_of_loops: int ## Number of times to loop through the action group. Set to 0 to infinitely loop.

var current_state: MovementPatternState ## The current MovementPatternState this pattern is in.
var children: Dictionary ## MovementAction nodes that are children of this pattern organised by their groups.
var current_group: ActionGroup ## The current MovementAction group to perform.
var current_action: int ## The current MovementAction this pattern is performing in the current group.
var current_loop: int ## Counter for group repeats if it is set to repeat. Only used if there are a finite number of loops.

func _ready() -> void:
	if (Engine.is_editor_hint()):
		return
	
	initialise_children_dictionary()
	for child in get_children():
		if child is MovementAction:
			child.set_parent(get_parent())
			child.finished.connect(_movement_action_action_completed)
			children[child.action_group].append(child)
		else:
			push_warning("Child \"" + child.name + "\" is not of type \"MovementAction\".")
	current_group = ActionGroup.ENTER
	current_action = 0
	current_loop = 0
	current_state = MovementPatternState.READY


func _movement_action_action_completed() -> void:
	emit_signal("action_finished", children[current_group][current_action].name)
	current_action += 1
	if (current_action >= children[current_group].size()):
		if (current_group == ActionGroup.ACTIVE || current_group == ActionGroup.RETIREMENT):
			var group_repeatable: bool = self.get(ActionGroup.keys()[current_group].to_lower() + "_repeatable")
			var group_total_loops: int = self.get(ActionGroup.keys()[current_group].to_lower() + "_num_of_loops")
			if (group_repeatable):
				current_loop += 1
				if (current_loop >= group_total_loops && group_total_loops != 0):
					reset_after_group_finished()
				else:
					reset_after_group_repeated()
			else:
				reset_after_group_finished()
		else:
			reset_after_group_finished()
	else:
		current_state = MovementPatternState.READY


## Starts the next action in the pattern.
func perform_next_action() -> void:
	if (current_state == MovementPatternState.READY):
		current_state = MovementPatternState.PERFORMING_ACTION
		children[current_group][current_action].perform()
		emit_signal("action_started", children[current_group][current_action].name)


## Stops the current action in the pattern and sets the pattern to COMPLETED state.
func force_stop() -> void:
	current_state = MovementPatternState.COMPLETED
	children[current_group][current_action].force_stop()


## Create typed arrays for each MovementAction group.
func initialise_children_dictionary() -> void:
	children[ActionGroup.ENTER] = Array([], TYPE_OBJECT, &"Node", MovementAction)
	children[ActionGroup.SETUP] = Array([], TYPE_OBJECT, &"Node", MovementAction)
	children[ActionGroup.ACTIVE] = Array([], TYPE_OBJECT, &"Node", MovementAction)
	children[ActionGroup.RETIREMENT] = Array([], TYPE_OBJECT, &"Node", MovementAction)
	children[ActionGroup.LEAVE] = Array([], TYPE_OBJECT, &"Node", MovementAction)


## Sets each counter variable to starting values to be ready for performing the next action group. Emits group_finished.
func reset_after_group_finished() -> void:
	current_loop = 0
	current_action = 0
	var finished_group: ActionGroup = current_group
	current_group = increment_to_next_group(current_group)
	current_state = MovementPatternState.READY
	emit_signal("group_finished", finished_group)


## Sets each counter variable to starting values to be ready for performing the same action group again. Emits group_repeated.
func reset_after_group_repeated() -> void:
	current_action = 0
	current_state = MovementPatternState.READY
	emit_signal("group_repeated", current_group)


## Increments the passed value to the next ActionGroup. If the next is empty it increments twice.
func increment_to_next_group(current: ActionGroup) -> ActionGroup:
	current += 1
	if (children[current].size() == 0):
		current += 1
	return current
