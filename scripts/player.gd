extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var lilypads: Node = $"../Lilypads"
@onready var initPosition = player.position

#const SPEED = 300.0
var distance : float = 500.0
var lastDirection : Vector2 = Vector2.ZERO
var lastObstacleFound : Node2D = null
#const JUMP_VELOCITY = -400.0
#var health = 100.0

func findObstacle(playerPosition : Vector2, direction: Vector2) -> Node2D:
	#for number in range(1, 15):
		#print(number)
	var playerX = playerPosition.x
	var playerY = playerPosition.y
	
	var obstacles = lilypads.get_children()
	var deltaX : float = distance + 1
	var deltaY : float = distance + 1
	var lastObstacle : Node2D = null
	var finalIcon : Node2D = null
	
	for obstacle in obstacles:
		if obstacle.name.substr(0, 4) == "Icon":
			var icon: Node2D = obstacle
			var currentDeltaX = icon.position.x - playerX
			var currentDeltaY = icon.position.y - playerY
				
			if direction == Vector2.UP:
				if currentDeltaY < deltaY:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX <= 100 && deltaX >= -100:
						if deltaY <= distance && deltaY > 0:
							finalIcon = icon
							lastObstacle = icon
			elif direction == Vector2.DOWN:
				if currentDeltaY < deltaY:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX <= 100 && deltaX >= -100:
						if deltaY >= -distance && deltaY < 0:
							finalIcon = icon
							lastObstacle = icon
			elif direction == Vector2.LEFT:
				if currentDeltaX < deltaX:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX >= -distance && deltaX < 0:
						if deltaY <= 100 && deltaY >= -100:
							finalIcon = icon
							lastObstacle = icon
			elif direction == Vector2.RIGHT:
				if currentDeltaX < deltaX:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX <= distance && deltaX > 0:
						if deltaY <= 100 && deltaY >= -100:
							finalIcon = icon
							lastObstacle = icon
				
	return lastObstacle

func _physics_process(delta):
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if direction != Vector2.ZERO:
		if lastDirection != direction:
			lastDirection = direction
			
			if lastObstacleFound != null:
				lastObstacleFound.emit_signal("stopped")
	
	if Input.is_action_just_released("initial_position"):
		player.position = initPosition
	
	if Input.is_action_just_released("confirm"):
		if lastObstacleFound != null:
			player.position = lastObstacleFound.position
			lastObstacleFound.queue_free()
			lastObstacleFound = null
			
	if direction != Vector2.ZERO:
		if lastDirection == Vector2.DOWN:
			var obstacle = findObstacle(player.get_position_delta(), Vector2.DOWN)
			
			if obstacle != null:
				print("Up!")
				lastDirection = Vector2.ZERO
				lastObstacleFound = obstacle
				obstacle.emit_signal("chosen")
		if lastDirection == Vector2.RIGHT:
			var obstacle = findObstacle(player.get_position_delta(), Vector2.RIGHT)
				
			if obstacle != null:
				print("Right!")
				lastDirection = Vector2.ZERO
				lastObstacleFound = obstacle
				obstacle.emit_signal("chosen")
		if lastDirection == Vector2.LEFT:
			var obstacle = findObstacle(player.get_position_delta(), Vector2.LEFT)
				
			if obstacle != null:
				print("Left!")
				lastDirection = Vector2.ZERO
				lastObstacleFound = obstacle
				obstacle.emit_signal("chosen")
		if lastDirection == Vector2.UP:
			var obstacle = findObstacle(player.get_position_delta(), Vector2.UP)
			
			if obstacle != null:
				print("Down!")
				lastDirection = Vector2.ZERO
				lastObstacleFound = obstacle
				obstacle.emit_signal("chosen")
