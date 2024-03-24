class_name Trail
extends Line2D

const MAX_LINE_POINTS: int = 120

var _is_detached: bool

# virtual methods
func _ready() -> void:
	clear_points()

func _physics_process(delta: float) -> void:
	if _is_detached:
		if get_point_count() > 0:
			remove_point(0)
		return
	if get_point_count() > MAX_LINE_POINTS:
		remove_point(0)

# public methods
func add_line_point(point) -> void:
	add_point(point)

func unparent_node() -> void:
	reparent(get_tree().current_scene)
	_is_detached = true
	# create fade out tween
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(_on_fade_out_finished)

# private methods
func _on_fade_out_finished() -> void:
	queue_free()
