extends Camera2D

var player: Player = null
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	global_position.x = viewport_size.x / 2
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x

func _process(_delta: float) -> void:
	var limit_distance := 420.0
	
	if player:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = player.global_position.y + limit_distance

func _physics_process(_delta: float) -> void:
	if player:
		global_position.y = player.global_position.y

func setup_camera(_player: Player):
	if _player:
		player = _player
