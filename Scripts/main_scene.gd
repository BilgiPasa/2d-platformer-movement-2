extends Node2D

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"): # If "esc" key pressed
		quit_game()

func quit_game() -> void:
	get_tree().quit()
