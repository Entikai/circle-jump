extends CollisionShape2D

func set_collision_shape_radius(new_radius: float) -> void:
	shape = shape.duplicate()
	shape.radius = new_radius
