extends Line2D

var trail_length = 25

func _process(delta: float) -> void:
	if points.size() > trail_length:
		remove_point(0)
	add_point(position)
