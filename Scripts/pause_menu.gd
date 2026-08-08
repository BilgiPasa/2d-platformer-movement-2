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
	# Initialize the version_label
	version_label.text = "v" + str(ProjectSettings.get_setting("application/config/version"))

	# Initialize the speed_label_on_off_button
	if !Globals.speed_label_visible:
		hide_speed_lbl.emit()
		speed_label_on_off_button.text = "Show Speed Label"
	else:
		show_speed_lbl.emit()
		speed_label_on_off_button.text = "Hide Speed Label"

	# Initialize the d_jump_on_off_button
	if !Globals.double_jump_enabled:
		d_jump_on_off_button.text = "Enable Double Jump"
	else:
		d_jump_on_off_button.text = "Disable Double Jump"

	# Initialize the sounds_on_off_button
	if !Globals.sounds_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		sounds_on_off_button.text = "Mute Sounds"
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		sounds_on_off_button.text = "Unmute Sounds"

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
	if Globals.speed_label_visible:
		Globals.speed_label_visible = false
		hide_speed_lbl.emit()
		speed_label_on_off_button.text = "Show Speed Label"
	else:
		Globals.speed_label_visible = true
		show_speed_lbl.emit()
		speed_label_on_off_button.text = "Hide Speed Label"

	Globals.preferences_save.save()

func _on_d_jump_on_off_btn_pressed() -> void:
	if Globals.double_jump_enabled:
		Globals.double_jump_enabled = false
		d_jump_on_off_button.text = "Enable Double Jump"
	else:
		Globals.double_jump_enabled = true
		d_jump_on_off_button.text = "Disable Double Jump"

	Globals.preferences_save.save()

func _on_sounds_on_off_btn_pressed() -> void:
	if Globals.sounds_muted:
		Globals.sounds_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		sounds_on_off_button.text = "Mute Sounds"
	else:
		Globals.sounds_muted = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		sounds_on_off_button.text = "Unmute Sounds"

	Globals.preferences_save.save()
