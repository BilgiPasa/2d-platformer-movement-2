class_name Player
extends CharacterBody2D

# Movement
const MOVE_SPEED: int = 500
const START_MOVE_DELTA: float = 0.2
const GROUND_STOP_DELTA: float = 0.2
const AIR_STOP_DELTA: float = 0.1
const BUMP_STOP_DELTA: float = 0.5
const MIN: float = 0.1
var horizontal: float = 0
var move_direction: float
var looking_right: bool = true
var bumping: bool
var movable_ground_under_player: CharacterBody2D = null # For player speed calculation

# Dash
const DASH_SPEED: int = 1000
const TRAIL_LINE_MAX_LENGTH: int = 12
const CAN_DASH_TIMER_SECONDS: float = 0.75
const DASHING_TIMER_SECONDS: float = 0.25
var can_dash: bool = true
var dashing: bool = false
var dash_input: bool
var trail_line_queue: Array[Vector2]

# Jump
const JUMP_POWER: int = 750
const NORMAL_GRAVITY: int = 2500
const FAST_FALL_GRAVITY: int = 4000
const COYOTE_TIME_SECONDS: float = 0.1
const JUMP_BUFFER_SECONDS: float = 0.2
var coyote_time_counter: float
var jump_buffer_counter: float
var released_jump: bool = false
var grounded: bool
var double_jumped: bool

# @export Variables
@export var trail_line: Line2D
@export var normal_jump_sound: AudioStreamPlayer2D
@export var double_jump_sound: AudioStreamPlayer2D
@export var dash_sound: AudioStreamPlayer2D
@export var can_dash_timer: Timer
@export var dashing_timer: Timer
@export var player_sprite: Sprite2D
@export var bump_area: Area2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	can_dash_timer.wait_time = CAN_DASH_TIMER_SECONDS
	dashing_timer.wait_time = DASHING_TIMER_SECONDS

func _process(_delta) -> void:
	move_direction = Input.get_axis("move_left", "move_right")
	dash_input = Input.is_action_pressed("dash")

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_SECONDS # Reset jump buffer
		released_jump = false # Reset released_jump

	if Input.is_action_just_released("jump"):
		released_jump = true

func _physics_process(delta: float) -> void:
	# * Normal movement
	movement()

	# * Handle dash and its trail line
	dash()
	handle_trail_line()

	# * Ground detection
	grounded = is_on_floor() # is_on_floor() is a built-in function for CharacterBody2D.

	# * Bump detection
	bumping = bump_area.has_overlapping_bodies()

	# * Jump buffer
	if jump_buffer_counter <= 0:
		jump_buffer_counter = 0
	else:
		jump_buffer_counter -= delta

	if grounded:
		# * Reset coyote time and double jump
		coyote_time_counter = COYOTE_TIME_SECONDS
		double_jumped = false
	else:
		# * Coyote time
		if coyote_time_counter <= 0:
			coyote_time_counter = 0
		else:
			coyote_time_counter -= delta

		# * Change gravity based on player's Y speed
		gravity_control(delta)

	# * Handle jump and variable jump height
	jump()

	move_and_slide() # Godot's built-in function to run the CharacterBody2D.

func movement() -> void:
	if dashing:
		return

	if move_direction >= MIN: # If player is moving right
		horizontal = move_toward(horizontal, 1, START_MOVE_DELTA)

		if !looking_right:
			flip()
	elif move_direction <= -MIN: # If player is moving left
		horizontal = move_toward(horizontal, -1, START_MOVE_DELTA)

		if looking_right:
			flip()
	else:
		if bumping:
			if horizontal >= MIN:
				horizontal = move_toward(horizontal, 0, BUMP_STOP_DELTA)
			elif horizontal <= -MIN:
				horizontal = move_toward(horizontal, 0, BUMP_STOP_DELTA)
			else:
				horizontal = 0
		elif grounded:
			if horizontal >= MIN:
				horizontal = move_toward(horizontal, 0, GROUND_STOP_DELTA)
			elif horizontal <= -MIN:
				horizontal = move_toward(horizontal, 0, GROUND_STOP_DELTA)
			else:
				horizontal = 0
		else:
			if horizontal >= MIN:
				horizontal = move_toward(horizontal, 0, AIR_STOP_DELTA)
			elif horizontal <= -MIN:
				horizontal = move_toward(horizontal, 0, AIR_STOP_DELTA)
			else:
				horizontal = 0

	velocity.x = horizontal * MOVE_SPEED

func dash() -> void:
	if dash_input && can_dash:
		can_dash = false
		can_dash_timer.start()
		dashing = true
		dashing_timer.start()
		dash_sound.play()

		if looking_right:
			velocity.x = DASH_SPEED
		else:
			velocity.x = -DASH_SPEED

func handle_trail_line() -> void:
	if dashing:
		trail_line_queue.push_front(position)

		if trail_line_queue.size() > TRAIL_LINE_MAX_LENGTH:
			trail_line_queue.pop_back()

		trail_line.clear_points()

		for i in trail_line_queue:
			trail_line.add_point(i)
	else:
		if trail_line_queue.size() > 0:
			trail_line_queue.pop_back()

			trail_line.clear_points()

			for i in trail_line_queue:
				trail_line.add_point(i)

func _on_can_dash_timer_timeout() -> void:
	can_dash_timer.stop()
	can_dash = true

func _on_dashing_timer_timeout() -> void:
	dashing_timer.stop()
	dashing = false

func gravity_control(physics_process_delta: float) -> void:
	if dashing:
		velocity.y = 0
		return

	if velocity.y >= MIN: # In Godot's 2D plane, Y vector increases as you go down.
		velocity += FAST_FALL_GRAVITY * physics_process_delta * Vector2.DOWN
	else:
		velocity += NORMAL_GRAVITY * physics_process_delta * Vector2.DOWN

func jump() -> void:
	if dashing:
		return

	if jump_buffer_counter > 0 && coyote_time_counter > 0: # Normal jump
		normal_jump_sound.play()
		execute_jump()
	elif Globals.double_jump_enabled && !double_jumped && jump_buffer_counter > 0 && !(coyote_time_counter > 0): # Double jump
		double_jumped = true
		double_jump_sound.play()
		execute_jump()

	# * Variable jump height
	if released_jump && velocity.y <= -MIN: # In Godot's 2D plane, Y vector decreases as you go up.
		released_jump = false
		velocity.y /= 2

func execute_jump() -> void:
	velocity.y = -JUMP_POWER # In Godot's 2D plane, Y vector increases as you go down.
	coyote_time_counter = 0
	jump_buffer_counter = 0

func flip() -> void:
	player_sprite.scale.x *= -1
	looking_right = !looking_right

func get_horizontal_speed() -> float:
	if movable_ground_under_player == null:
		return velocity.x
	else:
		return velocity.x + movable_ground_under_player.velocity.x

# On Movable Ground Area Body Entered
func _on_m_ground_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		movable_ground_under_player = body

# On Movable Ground Area Body Exited
func _on_m_ground_area_body_exited(body: Node2D) -> void:
	if movable_ground_under_player == body:
		movable_ground_under_player = null
