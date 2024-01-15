extends Node2D

@onready var platform_parent = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")
var viewport_size
var start_platform_y: float
var y_between_platforms := 100.0
var level_size := 10
var platform_count := 0
var player: Player = null

func setup(_player: Player):
	if _player:
		player = _player

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_between_platforms * 2)
	generate_level(start_platform_y, true)

func _process(_delta: float) -> void:
	if player:
		var player_y = player.global_position.y
		var end_of_level = start_platform_y - (platform_count * y_between_platforms)
		var threshold = end_of_level + (y_between_platforms * 6)
		
		if player_y <= threshold:
			generate_level(end_of_level, false)
	

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
