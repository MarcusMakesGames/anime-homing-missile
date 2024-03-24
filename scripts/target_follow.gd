extends Path2D

@export var move_speed: float = 90

var _path_length: float
var _progress_value: float

@onready var path_follow_2d: PathFollow2D = $PathFollow2D

# virtual methods
func _ready() -> void:
	_path_length = curve.get_baked_length()
	_progress_value = randf()

func _process(delta: float) -> void:
	_progress_value += move_speed * delta
	if _progress_value > _path_length:
		_progress_value -= _path_length
	
	path_follow_2d.progress = _progress_value
