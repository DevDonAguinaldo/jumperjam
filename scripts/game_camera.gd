extends Camera2D

@onready var destroyer: Area2D = $destroyer
@onready var destroyer_shape: CollisionShape2D = $destroyer/destroyer_shape


var player: Player = null
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	var rect_shape = RectangleShape2D.new()
	var rect_shape_size = Vector2(viewport_size.x, 200.0)
	
	global_position.x = viewport_size.x / 2
	limit_bottom = int(viewport_size.y)
	limit_left = 0
	limit_right = int(viewport_size.x)
	
	destroyer.position.y = viewport_size.y
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape

func _process(_delta: float) -> void:
	var limit_distance = 420
	var overlapping_areas = destroyer.get_overlapping_areas()
	
	if player:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
	
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area is Platform:
				area.queue_free()

func _physics_process(_delta: float) -> void:
	if player:
		global_position.y = player.global_position.y

func setup_camera(_player: Player):
	if _player:
		player = _player
