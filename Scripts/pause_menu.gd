extends Control

signal resume_game
signal show_speed_lbl
signal hide_speed_lbl

@export var resume_button: Button
@export var speed_label_on_off_button: Button
@export var d_jump_on_off_button: Button
@export var sounds_on_off_button: Button
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

func _on_spd_lbl_on_off_btn_pressed() -> void:
	if Globals.speed_label_hidden: # Show
		Globals.speed_label_hidden = false
		show_speed_lbl.emit()
		speed_label_on_off_button.text = "Hide Speed Label"
	else: # Hide
		Globals.speed_label_hidden = true
		hide_speed_lbl.emit()
		speed_label_on_off_button.text = "Show Speed Label"

func _on_d_jump_on_off_btn_pressed() -> void:
	if Globals.can_double_jump: # Disable
		Globals.can_double_jump = false
		d_jump_on_off_button.text = "Enable Double Jump"
	else: # Enable
		Globals.can_double_jump = true
		d_jump_on_off_button.text = "Disable Double Jump"

func _on_sounds_on_off_btn_pressed() -> void:
	if Globals.sounds_muted: # Unmute
		Globals.sounds_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		sounds_on_off_button.text = "Mute Sounds"
	else: # Mute
		Globals.sounds_muted = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		sounds_on_off_button.text = "Unmute Sounds"
