extends Area2D

signal ship_hit(lifes)

@onready var _animated_sprite = $AnimatedSprite2D
@onready var MAIN_SCENE = preload("res://scenes/main.tscn")
@onready var SHOOT_SCENE = preload("res://scenes/shoot.tscn")
@onready var _muzzle = $Marker2D
@onready var SHOOT_TIMER = $ShootTimer
@onready var CREATION_TIMER = $CreationTimer

@export var rotationSpeed = PI
@export var speed = 50 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
var velocity = Vector2.UP
var rotated_velocity = Vector2.UP
var rotation_value: float
var VEL_UP_LIM = 200
var lifes = 2

var imune = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	CREATION_TIMER.start()
	modulate.a = 0.5
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input and ship controlling
	if Input.is_action_pressed("rotate_clock_wise"):
		rotation_value = rotationSpeed * delta
		rotation += rotation_value
		rotated_velocity = rotated_velocity.rotated(rotation_value).normalized()
	if Input.is_action_pressed("rotate_anti_clock_wise"):
		rotation_value = -rotationSpeed * delta
		rotation += rotation_value
		rotated_velocity = rotated_velocity.rotated(rotation_value).normalized()
	if Input.is_action_pressed("push_foward"):
		if velocity.normalized().dot(rotated_velocity) != 1: # Easy way to rotate velocity
			var temp_lenght = velocity.length()
			velocity = rotated_velocity
			velocity = velocity * temp_lenght
			#velocity = velocity.rotated(velocity.dot(rotated_velocity)/(velocity.length()*rotated_velocity.length())) # Hard way, not working
		if velocity.length() < VEL_UP_LIM:
			velocity += velocity * speed * delta
			#if velocity.length() > VEL_UP_LIM:
			#	velocity = velocity.normalized() * VEL_UP_LIM
		position += velocity * delta
		_animated_sprite.animation = "fly"
	elif velocity.length() > 1: # Can't make the vector 0
		velocity -= velocity * 0.75 * delta # Breaking
		position += velocity * delta
		_animated_sprite.animation = "static"
	if Input.is_action_pressed("shoot") and SHOOT_TIMER.is_stopped():
		if not imune:
			shoot()
	
	global_funcs.teleport_edge($".")
	
	_animated_sprite.play()
	
func shoot():
	var a_shoot = SHOOT_SCENE.instantiate()
	var shoot_direction = rotated_velocity
	a_shoot.global_position = _muzzle.global_position
	a_shoot.direction = shoot_direction
	get_tree().root.add_child(a_shoot)
	
	SHOOT_TIMER.start()
	a_shoot.get_node("ShootDuration").start()


#func start(pos):
	#show()
	#$CollisionShape2D.disabled = false

func end_game():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if imune:
		return
	if area.is_in_group("Asteroids"):
		ship_hit.emit(lifes)
		queue_free()

func _on_creation_timer_timeout() -> void:
	imune = false
	modulate.a = 1
