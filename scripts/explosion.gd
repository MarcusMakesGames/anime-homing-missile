extends Area2D

const FULL_SCALE_DURATION: float = 0.5
const FADE_OUT_DURATION: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D

# private methods
func _ready() -> void:
	# start scale and fade out tween
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2.ONE, FULL_SCALE_DURATION)
	tween.tween_property(sprite_2d, "modulate:a", 0.0, FADE_OUT_DURATION)
	tween.tween_callback(_on_tween_finished)

func _on_tween_finished() -> void:
	queue_free()
