@tool
extends VisibleOnScreenNotifier2D

var waves: Array[StringName]

func _ready():
	$DebugData.visible = false
	for group_name in get_groups():
		if (group_name.begins_with("wave_")):
			waves.append(group_name)


func _draw():
	if (!Engine.is_editor_hint()):
		return
	
	$DebugData.visible = true
	for wave in waves:
		$DebugData.text = wave


func _activator_screen_entered():
	if (Engine.is_editor_hint()):
		return
	
	for wave in waves:
		get_tree().call_group(wave, "activate")
