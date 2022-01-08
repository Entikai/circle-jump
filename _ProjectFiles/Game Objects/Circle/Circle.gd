extends Area2D #https://youtu.be/I1noxf5LV4I?list=PLsk-HSGFjnaHH6JyhJI2w8JI76v1F6B-X&t=620

onready var collision_shape: Node2D = $CollisionShape2D
onready var sprite: Node2D = $Sprite
onready var orbit_position: Node2D = $Pivot/OrbitPosition
onready var pivot: Node2D = $Pivot
onready var animation_player = $AnimationPlayer
onready var label = $Label

enum MODES {STATIC, LIMITED}
var mode: int = MODES.STATIC
var number_of_orbits: int = 3
var current_orbits: int = 0
var orbit_start = null
var radius: float
var jumper_is_on_the_circle: bool = false
var game_over: bool = false


func _ready() -> void:
	EventBus.connect("game_over", self, "game_over")


func on_Circle_created(new_position, new_radius: float = 100, new_mode = MODES.LIMITED) -> void:
	radius = new_radius
	set_mode(new_mode)
	position = new_position
	collision_shape.set_collision_shape_radius(new_radius)
	sprite.set_sprite_scale(new_radius)
	orbit_position.set_orbit_x_position(new_radius)
	pivot.set_rotation_direction()


func set_mode(new_mode) -> void:
	mode = new_mode
	match mode:
		MODES.STATIC:
			label.hide()
		MODES.LIMITED:
			current_orbits = number_of_orbits
			label.text = str(current_orbits)
			label.show()


func _process(delta: float) -> void:
	if mode == MODES.LIMITED and jumper_is_on_the_circle == true and game_over == false:
		check_orbits()
		update()


func check_orbits():
	if abs (pivot.rotation - orbit_start) > 2 * PI: #This checks if jumper has gone full circle around the circle.
		current_orbits -= 1
		label.text = str(current_orbits)
		if current_orbits <= 0:
			on_Circle_abandoned()
			EventBus.emit_signal("game_over")
		orbit_start = pivot.rotation


func on_Circle_abandoned():
	animation_player.circle_abandoned()


func on_Circle_captured():
	animation_player.circle_captured()
	orbit_start = pivot.rotation


func get_circle_orbit_position() -> Transform2D:
	return orbit_position.global_transform


func jumper_is_on_the_circle(jumper_position: Vector2):
	jumper_is_on_the_circle = true
	set_pivot_rotation(jumper_position)


func set_pivot_rotation(jumper_position: Vector2) -> void:
	var starting_angle: float = (jumper_position - position).angle()
	pivot.rotation = starting_angle


func _draw() -> void:
	if jumper_is_on_the_circle == true:
		var rad = ((radius - 50) / number_of_orbits) * (1 + number_of_orbits - current_orbits) 
		draw_circle_arc_poly(Vector2.ZERO, rad + 10, orbit_start + PI/2, pivot.rotation + PI/2, Color(1,0,0) )

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func game_over() -> void:
	game_over = true
