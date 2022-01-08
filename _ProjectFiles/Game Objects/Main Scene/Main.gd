extends Node

var Circle := preload("res://_ProjectFiles/Game Objects/Circle/Circle.tscn")
var Jumper := preload("res://_ProjectFiles/Game Objects/Jumper/Jumper.tscn")

onready var camera: Node2D = $Camera2D
onready var start_position: Vector2 = $StartPosition.position

var player: Node2D


func _ready() -> void:
	randomize()
	new_player()


func new_player() -> void:
	setcamera_position(start_position)
	instanceplayer()
	player.connect("captured", self, "_on_Jumper_captured")
	spawn_circle(start_position, player)


func setcamera_position(new_position: Vector2) -> void:
	camera.position = new_position


func instanceplayer():
	player = Jumper.instance()
	player.position = start_position
	add_child(player)


func spawn_circle(circle_position = null, newplayer = player) -> void:
	var circle = Circle.instance()
	if circle_position == null and newplayer != null:
		circle_position = newplayer.active_circle.position + generate_random_vector()
	add_child((circle))
	circle.on_Circle_created(circle_position)


func generate_random_vector() -> Vector2:
	var x: float = rand_range(-150, 150)
	var y: float = rand_range(-500, -400)
	return Vector2(x, y)

func _on_Jumper_captured(object):
	setcamera_position(object.position)
	object.on_Circle_captured()
	call_deferred("spawn_circle")
