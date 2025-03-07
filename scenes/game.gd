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
var start_time = Time.get_unix_time_from_system()

func firstGeneration() -> void:
	var tileNumber = (rightCurrentXMap - leftCurrentXMap) / 16
	
	for i in tileNumber:
		for j in 6:
			var lilypad_scene = load("res://scenes/lilypad.tscn")
			var new_lilypad : AnimatedSprite2D = lilypad_scene.instantiate()
			add_child(new_lilypad)
			new_lilypad.name = "Lilypad"
			new_lilypad.reparent($Obstacles/Lilypads)
			new_lilypad.position = Vector2((i * 16) + 8, ((j + 3) * 16) + 8)
			print(new_lilypad.position)

func _ready() -> void:
	firstGeneration()
	game_speed = Timer.new()
	game_speed.timeout.connect(randomize)
	game_speed.autostart = true
	add_child(game_speed)
	
func randomize() -> void:
	if game_speed != null:
		camera_2d.offset.x += 16
		#control.get_child(1).get_child(0).Text = "lol"
		var end_time = Time.get_unix_time_from_system()
		var elapsed_time = (end_time - start_time)
		delete()
		tileAbove = tile_map_layer.get_cell_tile_data(Vector2i((player.position.x / 16), 0))
		leftCurrentXMap += 16
		rightCurrentXMap += 16
		createNewLine()
		game_speed.start(3 * timeMultiplier)

func createNewLine() -> void:
	var nonTakenPositions: Array[int] = []
	# Water creation + land
	for i in 6:
		var random = randi_range(0, 6)
		if random < 5:
			tile_map_layer.set_cell(Vector2i((rightCurrentXMap / 16) - 1, 3 + i), 0, Vector2i(1, 0), 0)
		else:
			nonTakenPositions.append(i)

func delete() -> void:
	for i in 12:
		tile_map_layer.erase_cell(Vector2i((leftCurrentXMap / 16) - 1, i))
		
#func _physics_process(delta: float) -> void:
	#if tileAbove == null:
		#get_tree().quit()
