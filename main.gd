extends Node2D

@onready var SHIP = preload("res://scenes/ship.tscn")
@onready var ASTEROID_SCENE = preload("res://scenes/asteroid.tscn")
@onready var HUD_SCENE = preload("res://scenes/hud.tscn")

@export var ASTEROIDS_QUANT = 4

var screen_size # Size of the game window.
var score: int
var hud


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	hud = HUD_SCENE.instantiate()
	score = 0
	hud.update_score(score)
	add_child(hud)
	
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game():
	create_ship(2)
	create_asteroids(4, Vector2.ZERO, 4)

func create_ship(lifes: int):
	var ship = SHIP.instantiate()
	ship.position = screen_size/2
	#ship.start(screen_size/2)
	ship.lifes = lifes
	ship.ship_hit.connect(_on_ship_hit)
	
	add_child(ship)
	
func _on_ship_hit(old_lifes):
	if old_lifes > 0:
		create_ship(old_lifes-1)

func create_asteroids(quant:int, pos: Vector2, stage:int):
	var asteroids = Array()
	for i in range(quant):
		var asteroid = ASTEROID_SCENE.instantiate()
		
		asteroid.global_position = set_asteroid_location(pos)
		asteroid.stage = stage
			
		asteroid.asteroid_hit.connect(_on_asteroid_hit)
		add_child(asteroid)
		
		asteroids.append(asteroid)

func _on_asteroid_hit(old_pos, old_stage):
	if old_stage == 1:
		score += 1
		hud.update_score(score)
		
	if old_stage > 1:
		for i in range (2):
			create_asteroids(1, old_pos, old_stage - 1)

func set_asteroid_location(pos):
	if pos != Vector2.ZERO: return pos
	
	var x_position: float
	var y_position: float
	
	while true:
		x_position = randf() * screen_size.x
		if x_position > (screen_size.x/2 - 80) and x_position < (screen_size.x/2 + 80):
			continue
		else: break
		
	while true:
		y_position = randf() * screen_size.y
		if y_position > (screen_size.y/2 - 80) and y_position < (screen_size.y/2 + 80):
			continue
		else: break
		
	return Vector2(x_position, y_position)
		
		
		
		
		
		
