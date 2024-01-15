extends Node2D

@onready var player: Player = $player
@onready var level_generator: Node2D = $level_generator

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	


