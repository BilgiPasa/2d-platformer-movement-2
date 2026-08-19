class_name PreferencesSave
extends Resource

# Pause Menu Preferences
@export var double_jump_enabled: bool = false
@export var sounds_muted: bool = false
@export var speed_label_visible: bool = true

const SAVE_PATH: String = "user://preferences_save.tres" # I'm using .tres because I want to make it easily modifiable.

func save() -> void:
	double_jump_enabled = Globals.double_jump_enabled
	sounds_muted = Globals.sounds_muted
	speed_label_visible = Globals.speed_label_visible
	ResourceSaver.save(self, SAVE_PATH)

static func load_or_create() -> PreferencesSave:
	if ResourceLoader.exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		return PreferencesSave.new()
