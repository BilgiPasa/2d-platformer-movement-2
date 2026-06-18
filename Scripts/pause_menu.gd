extends Control

signal resume_game

@export var resume_button: Button
@export var version_label: Label

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
