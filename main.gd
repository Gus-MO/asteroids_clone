extends Node2D

@onready var SHIP = preload("res://scenes/ship.tscn")
@onready var ASTEROID_SCENE = preload("res://scenes/asteroid.tscn")
@onready var HUD_SCENE = preload("res://scenes/hud.tscn")

@export var ASTEROIDS_QUANT = 4
@export var starting_lifes = 2

var _game_running = false
var score: int
var hud
var asteroids_array



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_asteroids(4, Vector2.ZERO, 4)
	create_hud(0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and not _game_running:
		new_game()
		_game_running = true


func new_game():
	create_ship(starting_lifes)
	
	get_tree().call_group("Asteroids", "queue_free")
	
	create_asteroids(4, Vector2.ZERO, 4)
	create_hud(starting_lifes)
	hud.start_game()

func game_over():
	print("game_over")
	hud.end_game()

func create_hud(lifes):
	if hud == null:
		hud = HUD_SCENE.instantiate()
	else:
		remove_child(hud)
	score = 0
	hud.update_score(score)
	hud.update_lifes(lifes)
	add_child(hud)

func create_ship(lifes: int):
	var ship = SHIP.instantiate()
	ship.position = global_funcs.screen_size/2
	#ship.start(screen_size/2)
	ship.lifes = lifes
	ship.ship_hit.connect(_on_ship_hit)
	
	add_child(ship)
	
func _on_ship_hit(old_lifes):
	print(old_lifes)
	hud.update_lifes(old_lifes - 1)
	if old_lifes > 0:
		create_ship(old_lifes-1)
	else:
		_game_running = false
		game_over()

func create_asteroids(quant:int, pos: Vector2, stage:int):
	asteroids_array = Array()
	for i in range(quant):
		var asteroid = ASTEROID_SCENE.instantiate()
		
		asteroid.global_position = set_asteroid_location(pos)
		asteroid.stage = stage
			
		asteroid.asteroid_hit.connect(_on_asteroid_hit)
		add_child(asteroid)
		
		asteroids_array.append(asteroid)

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
		x_position = randf() * global_funcs.screen_size.x
		if x_position > (global_funcs.screen_size.x/2 - 80) and x_position < (global_funcs.screen_size.x/2 + 80):
			continue
		else: break
		
	while true:
		y_position = randf() * global_funcs.screen_size.y
		if y_position > (global_funcs.screen_size.y/2 - 80) and y_position < (global_funcs.screen_size.y/2 + 80):
			continue
		else: break
		
	return Vector2(x_position, y_position)
		
		
		
		
		
		
