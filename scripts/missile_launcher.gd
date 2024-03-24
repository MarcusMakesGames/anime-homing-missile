extends Node2D

const MAX_BARREL_ANGLE: float = 45
const MISSILE_BARRAGE_INTERVAL: float = 0.075

@export_category("References")
@export var spawn_points: Array[Marker2D]
@export var missile_scene: PackedScene

var _in_barrage_shot: bool

@onready var barrel: Node2D = $Barrel

# virtual methods
func _input(event: InputEvent) -> void:
	if _in_barrage_shot:
		return
	
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if spawn_points.size() == 0:
					return
				_launch_single_missile(spawn_points.pick_random())
			MOUSE_BUTTON_RIGHT:
				_launch_barage_of_missiles()

func _process(delta: float) -> void:
	if _in_barrage_shot:
		return
	_rotate_barrel_towards_mouse_position()

# private methods
func _rotate_barrel_towards_mouse_position() -> void:
	var aim_direction = barrel.global_position.direction_to(get_global_mouse_position())
	var aim_angle: float = Vector2.UP.angle_to(aim_direction)
	var aim_angle_degrees: float = rad_to_deg(aim_angle)
	var clamped_angle_degrees: float = clampf(aim_angle_degrees, -MAX_BARREL_ANGLE, MAX_BARREL_ANGLE)
	barrel.rotation_degrees = clamped_angle_degrees

func _launch_single_missile(spawn_point: Marker2D) -> void:
	var missile = missile_scene.instantiate()
	get_tree().current_scene.add_child(missile)
	missile.global_position = spawn_point.global_position
	missile.rotation = Vector2.RIGHT.angle_to(-spawn_point.global_transform.y)

func _launch_barage_of_missiles() -> void:
	_in_barrage_shot = true
	
	for spawn_point in spawn_points:
		_launch_single_missile(spawn_point)
		await get_tree().create_timer(MISSILE_BARRAGE_INTERVAL).timeout
	
	spawn_points.reverse()
	_in_barrage_shot = false
