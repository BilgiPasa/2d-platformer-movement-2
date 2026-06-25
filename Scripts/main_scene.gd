extends Node2D

@export var player: Player
@export var speed_label: Label
@export var pause_menu: Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	speed_label.process_mode = Node.PROCESS_MODE_INHERIT
	speed_label.show()
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"): # If "esc" key pressed
		if !get_tree().paused:
			pause()
		else:
			resume()

func _physics_process(_delta) -> void:
	if speed_label.visible:
		speed_label.text = "Speed: %d" % abs(int(player.velocity.x))

func pause() -> void:
	get_tree().paused = true
	speed_label.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume() -> void:
	get_tree().paused = false

	if speed_label.visible:
		speed_label.process_mode = Node.PROCESS_MODE_INHERIT

	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_pause_menu_resume_game() -> void:
	resume()

func _on_pause_menu_show_speed_lbl() -> void:
	speed_label.process_mode = Node.PROCESS_MODE_INHERIT
	speed_label.show()

func _on_pause_menu_hide_speed_lbl() -> void:
	speed_label.process_mode = Node.PROCESS_MODE_DISABLED
	speed_label.hide()
