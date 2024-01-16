extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed := 300.0
var accelerometer_speed := 130.0
var gravity := 15.0
var max_fall_velocity := 1000.0
var jump_velocity := -800.0
var viewport_size
var use_accelerometer = false

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	var os_name = OS.get_name()
	
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true

func _process(_delta: float) -> void:
	# checks if player is moving upward
	if velocity.y < 0:
		if animation_player.current_animation != "jump":
			animation_player.play("jump")
	# checks if player is moving downward
	elif velocity.y > 0:
		if animation_player.current_animation != "fall":
			animation_player.play("fall")

func _physics_process(_delta: float) -> void:
	var margin = 20
	
	# apply gravity
	velocity.y += gravity
	
	# cap downward velocity
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity
	
	# horizontal movement
	if use_accelerometer:
		# mobile controls
		var mobile_input = Input.get_accelerometer()
		
		velocity.x = mobile_input.x * accelerometer_speed
	else:
		# pc controls
		var direction = Input.get_axis("move_left", "move_right")
		
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	# start movement
	move_and_slide()
	
	# limit horizontal movement
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
		
	if global_position.x < -margin:
		global_position.x = viewport_size.x + margin
	
func jump() -> void:
	velocity.y = jump_velocity
