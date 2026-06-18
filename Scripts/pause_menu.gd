extends Control

signal resume_game
signal show_speed_lbl
signal hide_speed_lbl

@export var resume_button: Button
@export var show_speed_button: Button
@export var enable_d_jump_btn: Button
@export var version_label: Label
var show_speed_button_is_on: bool = false
var enable_d_jump_btn_is_on: bool = false

func _ready():
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

func _on_show_speed_button_pressed() -> void:
	if show_speed_button_is_on:
		show_speed_button_is_on = false
		hide_speed_lbl.emit()
		show_speed_button.text = "Show Speed"
	else:
		show_speed_button_is_on = true
		show_speed_lbl.emit()
		show_speed_button.text = "Hide Speed"

func _on_enable_d_jump_btn_pressed() -> void:
	if enable_d_jump_btn_is_on:
		enable_d_jump_btn_is_on = false
		Globals.can_double_jump = false
		enable_d_jump_btn.text = "Enable Double Jump"
	else:
		enable_d_jump_btn_is_on = true
		Globals.can_double_jump = true
		enable_d_jump_btn.text = "Disable Double Jump"
