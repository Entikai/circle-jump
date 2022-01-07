extends Area2D

onready var pivot: Node2D = $Pivot
onready var orbit_position: Node2D = $Pivot/OrbitPosition
onready var collision_shape: Node2D = $CollisionShape2D
onready var sprite: Node2D = $Sprite
onready var animation_player = $AnimationPlayer

var rotation_speed: float = PI


func public_initialize(new_position, new_radius: float = 100) -> void:
	position = new_position
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.radius = new_radius
	set_sprite_scale(new_radius)
	orbit_position.position.x = new_radius + 25
	rotation_speed *= pow(-1, randi() % 2) #Randomize rotation


func set_sprite_scale(new_radius: float) -> void:
	var img_size: float = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1, 1) * new_radius / img_size


func _process(delta: float) -> void:
	pivot.rotation += rotation_speed * delta


func public_implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()


func public_capture():
	animation_player.play("capture")
	
