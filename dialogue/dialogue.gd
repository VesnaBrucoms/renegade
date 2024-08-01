extends Node2D

var lines: Array[DialogueLine] ## List of all DialogueLine children.

func _ready():
	for child in get_children():
		if (child is DialogueLine):
			lines.append(child)
		else:
			push_warning("Child \"" + child.name + "\" is not of type \"DialogueLine\".")
