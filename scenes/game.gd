extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var tile_map_layer: TileMapLayer = $Map/TileMapLayer
@export var isInProgress: bool = false
@onready var camera_2d: Camera2D = %Camera2D
var game_speed: Timer = null
var timeMultiplier = 1
var leftCurrentXMap = 16
var rightCurrentXMap = 592
var tileAbove = TileData.new()



func _ready() -> void:
	game_speed = Timer.new()
	game_speed.timeout.connect(randomize)
	game_speed.autostart = true
	add_child(game_speed)
	
func randomize() -> void:
	if game_speed != null:
		camera_2d.offset.x += 16
		delete()
		tileAbove = tile_map_layer.get_cell_tile_data(Vector2i((player.position.x / 16), 0))
		leftCurrentXMap += 16
		rightCurrentXMap += 16
		createNewLine()
		game_speed.start(0.5 * timeMultiplier)

func createNewLine() -> void:
	var nonTakenPositions: Array[int] = []
	# Water creation + land
	for i in 6:
		var random = randi_range(0, 6)
		if random < 5:
			tile_map_layer.set_cell(Vector2i((rightCurrentXMap / 16) - 1, 3 + i), 0, Vector2i(1, 0), 0)
		else:
			nonTakenPositions.append(i)
	print(nonTakenPositions)
func delete() -> void:
	for i in 12:
		tile_map_layer.erase_cell(Vector2i((leftCurrentXMap / 16) - 1, i))
		
func _physics_process(delta: float) -> void:
	print("yes")
	#if tileAbove == null:
		#get_tree().quit()
