extends Node

var double_jump_enabled: bool
var sounds_muted: bool
var speed_label_visible: bool
var preferences_save: PreferencesSave

func _ready() -> void:
	preferences_save = PreferencesSave.load_or_create()
	double_jump_enabled = preferences_save.double_jump_enabled
	sounds_muted = preferences_save.sounds_muted
	speed_label_visible = preferences_save.speed_label_visible
