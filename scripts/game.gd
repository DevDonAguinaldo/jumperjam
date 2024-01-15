extends Node2D

@onready var platform_parent: Node2D = $PlatformParent

var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")
var camera = null
var viewport_size
var start_platform_y: float
var y_between_platforms := 100.0
var level_size := 50
var platform_count := 0

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($player)
	add_child(camera)
	
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_between_platforms * 2)
	generate_level(start_platform_y, true)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	
	platform.global_position = location
	platform_parent.add_child(platform)
	
	return platform

func generate_level(y_start: float, generate_ground: bool):
	var platform_width := 136.0
	var ground_platform_count = (viewport_size.x / platform_width) + 1
	var ground_y_offset := 62.0
	
	if generate_ground == true:
		for i in range(ground_platform_count):
			var ground_location: Vector2 = Vector2(i * platform_width, viewport_size.y - ground_y_offset)
			create_platform(ground_location)
	
	for i in range(level_size):
		var max_x = viewport_size.x - platform_width
		var random_x = randf_range(0, max_x)
		var location: Vector2 = Vector2(0, 0)
		
		location.x = random_x
		location.y = y_start - (y_between_platforms * i)
		
		create_platform(location)
		platform_count += 1
