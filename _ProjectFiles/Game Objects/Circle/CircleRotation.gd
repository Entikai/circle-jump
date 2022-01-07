extends Node2D

var rotation_speed: float = PI

func set_rotation_direction() -> void:
	rotation_speed *= pow(-1, randi() % 2)

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
