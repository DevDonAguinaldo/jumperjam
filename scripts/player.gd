extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed := 300.0
var gravity := 15.0
var max_fall_velocity := 1000.0
var jump_velocity := -800.0
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect().size

func _process(delta: float) -> void:
	# checks if player is moving upward
	if velocity.y < 0:
		if animation_player.current_animation != "jump":
			animation_player.play("jump")
	# checks if player is moving downward
	elif velocity.y > 0:
		if animation_player.current_animation != "fall":
			animation_player.play("fall")

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	var margin = 20
	
	# apply gravity
	velocity.y += gravity
	
	# cap downward velocity
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity
	
	# horizontal movement
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
