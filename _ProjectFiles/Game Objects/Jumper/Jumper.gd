extends Area2D

signal captured

var velocity: Vector2 = Vector2(100, 0)
var jump_speed: int = 1000
var active_circle: Node2D = null


func _on_Jumper_area_entered(area: Area2D) -> void:
	active_circle = area
	set_active_circle_angle(active_circle)
	velocity = Vector2.ZERO
	emit_signal("captured", area)


func set_active_circle_angle(new_active_circle: Node2D) -> void:
	var _pivot: Node2D = new_active_circle.get_node("Pivot")
	var starting_angle: float = (position - new_active_circle.position).angle()
	_pivot.rotation = starting_angle


func _unhandled_input(event: InputEvent) -> void:
	if active_circle and event is InputEventScreenTouch and event.pressed:
		delete_active_circle(active_circle)
		active_circle = null
		jump(jump_speed)


func delete_active_circle(new_active_circle: Node2D) -> void:
	new_active_circle.on_Circle_abandoned()


func jump(_jump_speed: int) -> void:
	velocity = transform.x * _jump_speed


func _process(delta: float) -> void:


	if active_circle:
		stay_on_circle(active_circle)
	else:
		keep_moving_forward(delta, velocity)


func stay_on_circle(active_circle: Node2D) ->void:
	transform = active_circle.get_circle_orbit_position()


func keep_moving_forward(delta: float, velocity: Vector2) -> void:
	position += velocity * delta
