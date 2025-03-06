extends Node2D

@export var isInProgress: bool = false
@onready var camera_2d: Camera2D = %Camera2D
var game_speed: Timer = null
var timeMultiplier = 1

func _ready() -> void:
	game_speed = Timer.new()
	game_speed.timeout.connect(randomize)
	game_speed.autostart = true
	add_child(game_speed)
	
func randomize() -> void:
	if game_speed != null:
		print("hi")
		camera_2d.offset.x += 16
		game_speed.start(3 * timeMultiplier)
