extends Sprite


func set_sprite_scale(new_radius: float) -> void:
	var img_size: float = texture.get_size().x / 2
	scale = Vector2(1, 1) * new_radius / img_size
