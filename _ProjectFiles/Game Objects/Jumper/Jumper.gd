extends Area2D

signal captured

var velocity: Vector2 = Vector2(100, 0)
var jump_speed: int = 1000
var active_circle: Node2D = null


func _ready() -> void:
	EventBus.connect("game_over", self, "_on_EventBus_game_over")

func _on_Jumper_area_entered(area: Area2D) -> void:
	active_circle = area
	area.jumper_is_on_the_circle(position)
	velocity = Vector2.ZERO
	emit_signal("captured", area)


func _unhandled_input(event: InputEvent) -> void:
	if active_circle and event is InputEventScreenTouch and event.pressed:
		jump(jump_speed)
		delete_active_circle(active_circle)


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

func _on_EventBus_game_over():
	die()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !active_circle:
		die()

func die():
	queue_free()
