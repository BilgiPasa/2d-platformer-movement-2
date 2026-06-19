extends Node2D

@export var player: CharacterBody2D
@export var pause_menu: Control
@export var speed_label: Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	speed_label.process_mode = Node.PROCESS_MODE_DISABLED
	speed_label.hide()

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"): # If "esc" key pressed
		if !get_tree().paused:
			pause()
		else:
			resume()

func _physics_process(_delta) -> void:
	if speed_label.visible:
		speed_label.text = "Speed: %.1f" % abs(player.velocity.x)

func pause() -> void:
	get_tree().paused = true
	pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.show()
	speed_label.process_mode = Node.PROCESS_MODE_DISABLED

func resume() -> void:
	get_tree().paused = false
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()

	if speed_label.visible:
		speed_label.process_mode = Node.PROCESS_MODE_INHERIT

func _on_pause_menu_resume_game() -> void:
	resume()

func _on_pause_menu_show_speed_lbl() -> void:
	speed_label.process_mode = Node.PROCESS_MODE_INHERIT
	speed_label.show()

func _on_pause_menu_hide_speed_lbl() -> void:
	speed_label.process_mode = Node.PROCESS_MODE_DISABLED
	speed_label.hide()
