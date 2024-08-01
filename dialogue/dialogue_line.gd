class_name DialogueLine extends Node

enum Faction { REPUBLIC, KINGDOM }

@export var speaker_name: String ## Name of the character currently talking.
@export var line: String ## Spoken dialogue.
@export var faction: Faction ## The faction the speaker belongs to.
