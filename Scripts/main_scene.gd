extends Node2D

@export var pause_menu: Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"): # If "esc" key pressed
		if !Globals.game_paused:
			pause()
		else:
			resume()

func pause() -> void:
	Globals.game_paused = true
	pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.show()

func resume() -> void:
	Globals.game_paused = false
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()

func _on_pause_menu_resume_game() -> void:
	resume()
