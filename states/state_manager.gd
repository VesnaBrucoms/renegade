extends Node

const EXIT_OK: int = 0
const EXIT_NO_INITIAL: int = 1

@export var initial_state: String ## Unique name of the State to place at the top of the empty stack.

var children: Dictionary ## Child States of this manager organised by State name key to State object value.
var states: Array ## Stack of active states.
var current_state: State ## The current State at the top of the stack that is being processed.

func _ready() -> void:
	for child in get_children():
		if child is State:
			children[child.unique_name] = child
			child.set_visibility(false)
			connect_state_signals(child)
		else:
			push_warning("Child \"" + child.name + "\" is not of type \"State\".")
	
	states.push_back(children.get(initial_state))
	current_state = states.back()
	if (current_state == null):
		push_warning("\"initial_state\" not set, closing game.")
		get_tree().quit(EXIT_NO_INITIAL)
	else:
		current_state.enter()


func _process(_delta: float) -> void:
	if (current_state == null && states.size() == 0):
		get_tree().quit(EXIT_OK)
	elif (current_state == null && states.size() >= 0 && states.back() == null):
		push_warning("\"current_state\" not assigned to, but states are on the stack. Returning to previous.")
		states.pop_back()
		current_state = states.back()
	else:
		if (current_state && current_state.process_mode == PROCESS_MODE_DISABLED):
			current_state.process_mode = PROCESS_MODE_INHERIT
			current_state.set_visibility(true)


## Adds the given state to the top of the stack, and sets it as the current state.
func _state_pushed(new_state: String) -> void:
	var activated_state: State = children.get(new_state)
	states.push_back(activated_state)
	current_state.process_mode = PROCESS_MODE_DISABLED
	current_state.set_visibility(false)
	
	current_state = activated_state
	current_state.enter()


## Removes the state at the top of the stack. The state below the popped state is set as the current state.
func _state_popped() -> void:
	current_state.process_mode = PROCESS_MODE_DISABLED
	current_state.set_visibility(false)
	states.pop_back()
	
	current_state = states.back()
	if (current_state):
		current_state.enter()


## Removes the state at the top of the stack and adds the given state, then setting this as the current state.
func _state_replaced(new_state: String) -> void:
	var activated_state: State = children.get(new_state)
	current_state.process_mode = PROCESS_MODE_DISABLED
	current_state.set_visibility(false)
	states.pop_back()
	states.push_back(activated_state)
	
	current_state = activated_state
	current_state.enter()


## Connects the given state's signals to this manager's relevant callbacks.
func connect_state_signals(state: State) -> void:
	state.state_pushed.connect(_state_pushed)
	state.state_popped.connect(_state_popped)
	state.state_replaced.connect(_state_replaced)
