class_name DialogueManager extends Node2D

signal completed ## Emitted when the given dialogue lines have finished playing.

enum DialogueState { READY = 0, PROCESSING = 1 }

var current_state: DialogueState ## Current DialogueState the manager is in.
var current_lines: Array[DialogueLine] ## An array of DialogueLines sent by a requesting scene.
var current_line: int ## The current processing line.

func _ready():
	current_state = DialogueState.READY
	$LineTimer.wait_time = 2


func _dialogue_started(lines: Array[DialogueLine]) -> void:
	if (current_state == DialogueState.READY):
		current_state = DialogueState.PROCESSING
		current_lines = lines
		current_line = 0
		var line = current_lines[current_line]
		set_displayed_dialogue(line.speaker_name, line.line, line.faction)
		$DialogueBox.visible = true
		$LineTimer.start()
	else:
		push_warning("New dialogue received while processing, ignoring.")


func _line_timer_timeout() -> void:
	current_line += 1
	if (current_line == current_lines.size()):
		$LineTimer.stop()
		$DialogueBox.visible = false
		current_state = DialogueState.READY
		emit_signal("completed")
	else:
		var line = current_lines[current_line]
		set_displayed_dialogue(line.speaker_name, line.line, line.faction)


## Updates the name, line, and background of the DialogueBox to the passed values.
func set_displayed_dialogue(speaker_name: String, line: String, speaker_faction: DialogueLine.Faction) -> void:
	$DialogueBox.speaker_name = speaker_name
	$DialogueBox.speaker_line = line
	if (speaker_faction == DialogueLine.Faction.KINGDOM):
		$DialogueBox.set_kingdom_background()
	elif (speaker_faction == DialogueLine.Faction.REPUBLIC):
		$DialogueBox.set_republic_background()
