extends CharacterBody2D

# Horizontal Movement
const MOVE_SPEED: int = 500
const START_MOVE_DELTA: float = 0.25
const GROUND_STOP_DELTA: float = 0.2
const AIR_STOP_DELTA: float = 0.1
const BUMP_STOP_DELTA: float = 0.3
const MIN: float = 0.1
var horizontal: float = 0
var move_direction: float
var bumping: bool

# Jump
const JUMP_POWER: int = 750
const NORMAL_GRAVITY: int = 2000
const FAST_FALL_GRAVITY: int = 2500
const COTOYE_TIME_SECONDS: float = 0.1
const JUMP_BUFFER_SECONDS: float = 0.2
var coyote_time_counter: float
var jump_buffer_counter: float
var double_jumped: bool = false
var grounded: bool

func _process(_delta):
	move_direction = Input.get_axis("move_left", "move_right") # Get horizontal inputs

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_SECONDS # Reset jump buffer

func _physics_process(delta: float) -> void:
	# * Handle horizontal movement
	if move_direction > 0:
		horizontal = move_toward(horizontal, 1, START_MOVE_DELTA)
	elif move_direction < 0:
		horizontal = move_toward(horizontal, -1, START_MOVE_DELTA)
	else:
		if !bumping:
			if grounded:
				if horizontal > MIN:
					horizontal = move_toward(horizontal, 0, GROUND_STOP_DELTA)
				elif horizontal < -MIN:
					horizontal = move_toward(horizontal, 0, GROUND_STOP_DELTA)
				else:
					horizontal = 0
			else:
				if horizontal > MIN:
					horizontal = move_toward(horizontal, 0, AIR_STOP_DELTA)
				elif horizontal < -MIN:
					horizontal = move_toward(horizontal, 0, AIR_STOP_DELTA)
				else:
					horizontal = 0
		else:
			if horizontal > MIN:
				horizontal = move_toward(horizontal, 0, BUMP_STOP_DELTA)
			elif horizontal < -MIN:
				horizontal = move_toward(horizontal, 0, BUMP_STOP_DELTA)
			else:
				horizontal = 0

	velocity.x = horizontal * MOVE_SPEED

	# For testing
	#print("velocity.x = " + str(velocity.x) + "\nhorizontal = " + str(horizontal) + "\n")

	# * Handle ground detection
	grounded = is_on_floor() # is_on_floor() is a built-in function for character controller.

	# * Handle jump buffer
	if jump_buffer_counter <= 0:
		jump_buffer_counter = 0
	else:
		jump_buffer_counter -= delta

	if grounded:
		# * Reset coyote time and double jump
		coyote_time_counter = COTOYE_TIME_SECONDS
		double_jumped = false
	else:
		# * Handle coyote time
		if coyote_time_counter <= 0:
			coyote_time_counter = 0
		else:
			coyote_time_counter -= delta

		# * Add the gravity based on player's Y speed
		if (velocity.y > 0): # In Godot's 2D plane, Y vector increases as you go down.
			velocity += FAST_FALL_GRAVITY * delta * Vector2.DOWN
		else:
			velocity += NORMAL_GRAVITY * delta * Vector2.DOWN

	# * Handle jump
	if jump_buffer_counter > 0 && coyote_time_counter > 0: # Normal jump
		# TODO: Play the normal jump sound here
		jump()
	elif !double_jumped && jump_buffer_counter > 0 && !(coyote_time_counter > 0): # Double jump
		# TODO: Play the double jump sound here
		double_jumped = true
		jump()

	move_and_slide() # Godot's built-in function to run the character controller.

func jump() -> void:
	velocity.y = -JUMP_POWER # In Godot's 2D plane, Y vector increases as you go down.
	coyote_time_counter = 0
	jump_buffer_counter = 0
