extends Area2D


func on_Circle_created(new_position, new_radius: float = 100) -> void:
	position = new_position
	$CollisionShape2D.set_collision_shape_radius(new_radius)
	$Sprite.set_sprite_scale(new_radius)
	$Pivot/OrbitPosition.set_orbit_x_position(new_radius)
	$Pivot.set_rotation_direction()


func on_Circle_abandoned():
	$AnimationPlayer.circle_abandoned()


func on_Circle_captured():
	$AnimationPlayer.circle_captured()


func get_circle_orbit_position() -> Vector2:
	return $Pivot/OrbitPosition.global_transform
