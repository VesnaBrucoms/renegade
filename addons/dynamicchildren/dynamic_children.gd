@tool
extends EditorInspectorPlugin

func _can_handle(object):
	return object is Enemy


func _parse_category(object, category):
	if (category == "enemy.gd"):
		for child in object.get_node("MovementPattern").get_children():
			for child_property in child.get_property_list():
				if (child_property["usage"] == PROPERTY_USAGE_DEFAULT):
					var new_prop = ActionProperty.new()
					new_prop.set_label(child.name + child_property["name"])
					add_property_editor(category, new_prop)
