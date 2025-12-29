extends Node

@onready var SCORE = $Score
@onready var PLAYER_LIFE = $PlayerLife
@onready var START_GAME = $StartGame
@onready var ASTEROIDS = $Asteroids

var ship_sprite: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score(score):
	if SCORE:
		SCORE.text = str(score)
	
func start_game():
	START_GAME.hide()
	ASTEROIDS.hide()
	
func end_game():
	START_GAME.show()
	ASTEROIDS.show()

func update_lifes(lifes: int):
	if not ship_sprite == null:
		for i in range(ship_sprite.size()):
			remove_child(ship_sprite[i])
	for life in range(lifes):
		ship_sprite.append(Sprite2D.new())
		var texture = load("res://art/ship_static.png")
		var scale = 0.25
		var ship_width: float

		ship_sprite[life].scale = Vector2(scale, scale)
		ship_sprite[life].texture = texture
		ship_width = ship_sprite[life].texture.get_width() * scale
		
		ship_sprite[life].position = Vector2(
									global_funcs.screen_size.x - ship_width*(life+1)*1.2, # Ships gonna be little separated
									ship_sprite[life].texture.get_height()*scale
									)
		
		add_child(ship_sprite[life])
