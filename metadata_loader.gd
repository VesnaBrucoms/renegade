extends Node

@export var mtd_path: String

func load_metadata(mtd_filename, campaign) -> void:
	var full_path = mtd_path + "/" + mtd_filename + ".mtd"
	if (!FileAccess.file_exists(full_path)):
		return
	var file = FileAccess.open(full_path, FileAccess.READ)
	
	while (file.get_position() < file.get_length()):
		var next_line = file.get_line()
		if (next_line == "" || next_line == "{" || next_line == "}"):
			continue
		
		if (next_line.begins_with("campaign=")):
			var equals_index = next_line.find("=")
			var cam_id = next_line.substr(equals_index + 1)
			print(str(campaign.id == cam_id))
		elif (next_line.begins_with("level=")):
			var equals_index = next_line.find("=")
			var level_id = next_line.substr(equals_index + 1)
			var data = load_level_metadata(file)
			for level in campaign.levels:
				if (level.filename == level_id):
					level.high_score = data[0]
					level.achieved_star = data[1]


func load_level_metadata(file) -> Array:
	var next_line
	var data = []
	while (next_line != "}"):
		next_line = file.get_line()
		if (next_line == "" || next_line == "{" || next_line == "}"):
			continue
		
		if (data.size == 0):
			data[0] = int(next_line)
		else:
			data[1] = next_line
	
	return data
