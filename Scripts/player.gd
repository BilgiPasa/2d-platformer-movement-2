class_name Player
extends CharacterBody2D

# Horizontal Movement
const MOVE_SPEED: int = 500
const START_MOVE_DELTA: float = 0.2
const GROUND_STOP_DELTA: float = 0.2
const AIR_STOP_DELTA: float = 0.1
const BUMP_STOP_DELTA: float = 0.5
const MIN: float = 0.1
var horizontal: float = 0
var move_direction: float
var looking_left: bool = false
var bumping: bool

# Jump
const JUMP_POWER: int = 750
const NORMAL_GRAVITY: int = 2500
const FAST_FALL_GRAVITY: int = 3000
const COTOYE_TIME_SECONDS: float = 0.1
const JUMP_BUFFER_SECONDS: float = 0.2
var coyote_time_counter: float
var jump_buffer_counter: float
var released_jump: bool = false
var grounded: bool
var double_jumped: bool

# @export Variables
@export var player_sprite: Sprite2D
@export var bump_area: Area2D
@export var normal_jump_sound: AudioStreamPlayer2D
@export var double_jump_sound: AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(_delta) -> void:
	move_direction = Input.get_axis("move_left", "move_right") # Get horizontal inputs

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_SECONDS # Reset jump buffer
		released_jump = false # Reset released_jump

	if Input.is_action_just_released("jump"):
		released_jump = true

func _physics_process(delta: float) -> void:
	# * Handle horizontal movement
	if move_direction > 0:
		horizontal = move_toward(horizontal, 1, START_MOVE_DELTA)

		if looking_left:
			flip()
	elif move_direction < 0:
		horizontal = move_toward(horizontal, -1, START_MOVE_DELTA)

		if !looking_left:
			flip()
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

	# * Handle ground detection
	grounded = is_on_floor() # is_on_floor() is a built-in function for CharacterBody2D.

	# * Handle bump detection
	bumping = bump_area.has_overlapping_bodies()

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

		# * Handle gravity based on player's Y speed
		if (velocity.y > 0): # In Godot's 2D plane, Y vector increases as you go down.
			velocity += FAST_FALL_GRAVITY * delta * Vector2.DOWN
		else:
			velocity += NORMAL_GRAVITY * delta * Vector2.DOWN

	# * Handle jump
	if jump_buffer_counter > 0 && coyote_time_counter > 0: # Normal jump
		normal_jump_sound.play()
		jump()
	elif Globals.can_double_jump && !double_jumped && jump_buffer_counter > 0 && !(coyote_time_counter > 0): # Double jump
		double_jumped = true
		double_jump_sound.play()
		jump()

	# * Variable jump height
	if released_jump && velocity.y < -MIN: # In Godot's 2D plane, Y vector decreases as you go up.
		released_jump = false
		velocity.y /= 2

	move_and_slide() # Godot's built-in function to run the CharacterBody2D.

func jump() -> void:
	velocity.y = -JUMP_POWER # In Godot's 2D plane, Y vector increases as you go down.
	coyote_time_counter = 0
	jump_buffer_counter = 0

func flip() -> void:
	player_sprite.scale.x *= -1
	looking_left = !looking_left
