extends CharacterBody2D

const MOVE_SPEED: int = 300
const JUMP_POWER: int = 400
const NORMAL_GRAVITY: int = 9
const FAST_FALL_GRAVITY: int = 14
const COTOYE_TIME_SECONDS: float = 0.1
const JUMP_BUFFER_SECONDS: float = 0.2
var coyote_time_counter: float
var jump_buffer_counter: float
var double_jumped: bool = false
var move_direction: float

func _input(event) -> void:
	if event.is_action_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_SECONDS # Reset jump buffer

func _physics_process(delta: float) -> void:
	# Manage jump buffer
	if jump_buffer_counter <= 0:
		jump_buffer_counter = 0
	else:
		jump_buffer_counter -= delta

	if is_on_floor():
		# Reset coyote time and double jump
		coyote_time_counter = COTOYE_TIME_SECONDS
		double_jumped = false
	else:
		# Manage coyote time
		if coyote_time_counter <= 0:
			coyote_time_counter = 0
		else:
			coyote_time_counter -= delta

		# Add the gravity based on player's Y speed
		if (velocity.y > 0): # In Godot's 2D plane, Y vector increases as you go down.
			velocity += FAST_FALL_GRAVITY * delta * Vector2.DOWN
		else:
			velocity += NORMAL_GRAVITY * delta * Vector2.DOWN

	# Handle jump
	if jump_buffer_counter > 0 && coyote_time_counter > 0: # Normal jump
		# TODO: Play the normal jump sound here
		jump()
	elif !double_jumped && jump_buffer_counter > 0 && !(coyote_time_counter > 0): # Double jump
		# TODO: Play the double jump sound here
		double_jumped = true
		jump()

	# Get the input direction
	move_direction = Input.get_axis("move_left", "move_right")

	# Handle the movement
	if move_direction:
		velocity.x = move_direction * MOVE_SPEED # Acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED) # Deceleration

	move_and_slide() # Godot's built-in function to run the character controller.

func jump() -> void:
	velocity.y = -JUMP_POWER # In Godot's 2D plane, Y vector increases as you go down.
	coyote_time_counter = 0
	jump_buffer_counter = 0
