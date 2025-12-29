extends Area2D

const SPEED = 600

var direction: Vector2:
	set(value):
		direction = value.normalized()
		if is_instance_valid(sprite_2d):
			sprite_2d.rotation = direction.angle()

@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(direction * SPEED * delta)
	global_funcs.teleport_edge($".")


func _on_shoot_duration_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Asteroids"):
		queue_free()
