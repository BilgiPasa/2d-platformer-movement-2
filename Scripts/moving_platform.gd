extends CharacterBody2D

@export var change_direction_timer: Timer
const MOVE_SPEED: int = 150
const CHANGE_DIRECTION_TIMER_SECONDS: int = 2
var move_right: bool = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	change_direction_timer.wait_time = CHANGE_DIRECTION_TIMER_SECONDS
	change_direction_timer.start()

func _physics_process(_delta: float) -> void:
	if move_right:
		velocity.x = MOVE_SPEED
	else:
		velocity.x = -MOVE_SPEED

	move_and_slide()

# On Change Direction Timer Timeout
func _on_change_direc_timer_timeout() -> void:
	move_right = !move_right
