class_name HomingMissile
extends Area2D

@export_category("Movement")
@export var move_speed_start: float = 100
@export var move_speed_acceleration: float = 10
@export var move_speed_max: float = 200

@export_category("Durations")
@export var lock_on_delay: float = 0.15
@export var max_life_time: float = 10

@export_category("Target Alignment")
@export var aim_rotation_speed: float = 6

@export_category("Aim Point Offsets")
@export var target_distance_min: float = 10
@export var target_distance_max: float = 120

@export var forward_offset_range_min: float = 10
@export var forward_offset_range_max: float = 150

@export var lateral_offset_amplitude_min: float = 10
@export var lateral_offset_amplitude_max: float = 150
@export var lateral_offset_amplitude_speed_min: float = 3.5
@export var lateral_offset_amplitude_speed_max: float = 4.5

@export_category("References")
@export var trail_node: Trail
@export var explosion_scene: PackedScene

var _life_time: float
var _move_speed: float
var _locked_on: bool
var _target: Node2D
var _lateral_amplitude_offset: float
var _lateral_amplitude_speed: float
var _aim_point: Vector2

# virtual methods
func _ready() -> void:
	_move_speed = move_speed_start
	_lateral_amplitude_offset = randf() * PI
	_lateral_amplitude_speed = randf_range(lateral_offset_amplitude_speed_min, lateral_offset_amplitude_speed_max)

func _process(delta: float) -> void:
	_life_time += delta
	
	if _locked_on:
		_calculate_aim_point()
		_rotate_towards_aim_point(delta)
		
		if _life_time > max_life_time:
			_spawn_explosion()
			_unparent_trail()
			queue_free()
	else:
		if _life_time > lock_on_delay:
			_find_closest_target()
			_locked_on = true
	
	_increase_move_speed(delta)
	_move_forward(delta)
	
	if trail_node:
		trail_node.add_line_point(global_position)

# private methods
func _increase_move_speed(delta: float) -> void:
	_move_speed += move_speed_acceleration * delta
	_move_speed = clampf(_move_speed, 0, move_speed_max)

func _move_forward(delta: float) -> void:
	position += _move_speed * delta * transform.x

func _find_closest_target() -> void:
	var closest_distance: float = 10000
	for target in get_tree().get_nodes_in_group("Targets"):
		var distance_to_target: float = global_position.distance_to(target.global_position)
		if distance_to_target < closest_distance:
			_target = target
			closest_distance = distance_to_target

func _calculate_aim_point() -> void:
	if _target == null:
		return
	
	# calculate target range weight (0 = closest, 1 = farthest)
	var target_distance: float = global_position.distance_to(_target.global_position)
	var target_distance_weight: float = inverse_lerp(target_distance_min, target_distance_max, target_distance)
	target_distance_weight = clampf(target_distance_weight, 0, 1)
	
	# calculate forward offset
	var forward_direction: Vector2 = global_position.direction_to(_target.global_position)
	var forward_length: float = lerpf(forward_offset_range_min, forward_offset_range_max, target_distance_weight)
	var forward_offset: Vector2 = forward_direction * forward_length
	
	# calculate offset on left/right side of target
	var lateral_direction: Vector2 = forward_direction.rotated(deg_to_rad(90))
	var lateral_amplitude: float = sin(_lateral_amplitude_offset + (_life_time * _lateral_amplitude_speed))
	var lateral_length: float = lerpf(lateral_offset_amplitude_min, lateral_offset_amplitude_max, target_distance_weight)
	var lateral_offset: Vector2 = lateral_direction * lateral_amplitude * lateral_length
	
	# calculate final aim point
	_aim_point = _target.global_position + forward_offset + lateral_offset

func _rotate_towards_aim_point(delta: float) -> void:
	var aim_direction: Vector2 = global_position.direction_to(_aim_point)
	var aim_angle: float = Vector2.RIGHT.angle_to(aim_direction)
	rotation = lerp_angle(rotation, aim_angle, aim_rotation_speed * delta)

func _spawn_explosion() -> void:
	if explosion_scene:
		var explosion: Area2D = explosion_scene.instantiate()
		get_tree().current_scene.call_deferred("add_child", explosion)
		explosion.global_position = global_position

func _unparent_trail() -> void:
	if trail_node:
		trail_node.unparent_node()

func _on_impact(area: Area2D) -> void:
	_spawn_explosion()
	_unparent_trail()
	queue_free()
