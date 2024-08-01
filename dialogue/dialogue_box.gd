extends Control

var speaker_name: String:
	set(value):
		$PanelContainer/GridContainer/Name.text = value
var speaker_line: String:
	set(value):
		$LineBackgroundKingdom/Dialogue.text = value
		$LineBackgroundRepublic/Dialogue.text = value

## Sets the displayed background to the kingdom's.
func set_kingdom_background():
	$LineBackgroundKingdom.visible = true
	$PanelContainer/NameBackgroundKingdom.visible = true
	$LineBackgroundRepublic.visible = false
	$PanelContainer/NameBackgroundRepublic.visible = false


## Sets the displayed background to the republic's.
func set_republic_background():
	$LineBackgroundKingdom.visible = false
	$PanelContainer/NameBackgroundKingdom.visible = false
	$LineBackgroundRepublic.visible = true
	$PanelContainer/NameBackgroundRepublic.visible = true
