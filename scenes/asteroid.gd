extends Area2D

signal asteroid_hit(current_position, stage)

@export var stage: int

@onready var HUD_SCENE = preload("res://scenes/HUD.tscn")

@onready var col_1 = $Asteroid1
@onready var col_2 = $Asteroid2
@onready var col_3 = $Asteroid3
@onready var col_4 = $Asteroid4
@onready var sprite = $AnimatedSprite2D
@onready var CREATION_TIMER = $CreationTimer


var SPEED = 50
var imune = true

var direction: Vector2:
	set(value):
		direction = value.normalized()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = initial_speed()
	CREATION_TIMER.start()
	modulate.a = 0.5
	
	match stage:
		4:
			sprite.play("4")
		3:
			sprite.play("3")
			col_4.set_deferred("disabled", true)
			col_3.set_deferred("disabled", false)
			SPEED = 100
			direction = initial_speed()
		2: 
			sprite.play("2")
			col_3.set_deferred("disabled", true)
			col_2.set_deferred("disabled", false)
			SPEED = 150
			direction = initial_speed()
		1: 
			sprite.play("1")
			col_2.set_deferred("disabled", true)
			col_1.set_deferred("disabled", false)
			SPEED = 200
			direction = initial_speed()
		_: 
			HUD_SCENE.score_update()
			queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(direction * SPEED * delta)
	global_funcs.teleport_edge($".")
		
		
func initial_speed():
	return Vector2.RIGHT.rotated(randf_range(0, TAU)).normalized()

func _on_area_entered(area: Area2D) -> void:
	if imune:
		return
	if area.is_in_group("Ship") or area.is_in_group("Shoots"):
		asteroid_hit.emit(global_position, stage)
		queue_free()


func _on_creation_time_timeout() -> void:
	imune = false
	modulate.a = 1.0
