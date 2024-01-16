extends Node2D

@onready var level_generator: Node2D = $level_generator
@onready var ground_sprite: Sprite2D = $ground_sprite
@onready var parallax_layer_1: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3

var player_scene = preload("res://scenes/player.tscn")
var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null
var player: Player = null
var player_spawn: Vector2
var viewport_size: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	var spawn_y_offset = 135
	
	player_spawn.x = viewport_size.x / 2.0
	player_spawn.y = viewport_size.y - spawn_y_offset
	
	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax_layer_1)
	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	
	new_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func new_game():
	player = player_scene.instantiate()
	camera = camera_scene.instantiate()
	
	player.global_position = player_spawn
	camera.setup_camera(player)
	
	add_child(player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)

func get_parallax_scale(parallax_sprite: Sprite2D) -> Vector2:
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	var parallax_scale = viewport_size.x / parallax_texture_width
	var result = Vector2(parallax_scale, parallax_scale)
	
	return result

func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	
	if parallax_sprite != null:
		parallax_sprite.scale = get_parallax_scale(parallax_sprite)
		var mirroring_y = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = mirroring_y
