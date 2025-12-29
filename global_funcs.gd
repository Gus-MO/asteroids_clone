extends Node2D

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func teleport_edge(obj):
	if obj.position.x > screen_size.x:
		obj.position = Vector2(0, obj.position.y)
	if obj.position.y > screen_size.y:
		obj.position = Vector2(obj.position.x, 0)
	if obj.position.x < 0:
		obj.position = Vector2(screen_size.x, obj.position.y)
	if obj.position.y < 0:
		obj.position = Vector2(obj.position.x, screen_size.y)
