extends Control

signal resume_game
signal show_speed_lbl
signal hide_speed_lbl

@export var resume_button: Button
@export var hide_speed_button: Button
@export var enable_d_jump_btn: Button
@export var mute_sounds_btn: Button
@export var version_label: Label

func _ready() -> void:
	version_label.text = "v" + str(ProjectSettings.get_setting("application/config/version"))

func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	resume_game.emit()

func _on_quit_game_button_pressed() -> void:
	quit_game()

func quit_game() -> void:
	get_tree().quit()

func _on_hide_speed_button_pressed() -> void:
	if Globals.speed_label_is_hidden: # Show
		Globals.speed_label_is_hidden = false
		show_speed_lbl.emit()
		hide_speed_button.text = "Hide Speed"
	else: # Hide
		Globals.speed_label_is_hidden = true
		hide_speed_lbl.emit()
		hide_speed_button.text = "Show Speed"

func _on_enable_d_jump_btn_pressed() -> void:
	if Globals.can_double_jump: # Disable
		Globals.can_double_jump = false
		enable_d_jump_btn.text = "Enable Double Jump"
	else: # Enable
		Globals.can_double_jump = true
		enable_d_jump_btn.text = "Disable Double Jump"

func _on_mute_sounds_btn_pressed() -> void:
	if Globals.sounds_muted: # Unmute
		Globals.sounds_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		mute_sounds_btn.text = "Mute Sounds"
	else: # Mute
		Globals.sounds_muted = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		mute_sounds_btn.text = "Unmute Sounds"
