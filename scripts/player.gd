extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var lilypads: Node = $"../Lilypads"
@onready var initPosition = player.position

#const SPEED = 300.0
var distance : float = 500.0
var lastDirection : Vector2 = Vector2.ZERO
#const JUMP_VELOCITY = -400.0
#var health = 100.0

func findObstacle(playerPosition : Vector2, direction: Vector2) -> Vector2:
	#for number in range(1, 15):
		#print(number)
	var playerX = playerPosition.x
	var playerY = playerPosition.y
	
	var obstacles = lilypads.get_children()
	var deltaX : float = distance + 1
	var deltaY : float = distance + 1
	var obstaclePosition : Vector2 = Vector2.ZERO
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
							obstaclePosition = icon.position
			elif direction == Vector2.DOWN:
				if currentDeltaY < deltaY:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX <= 100 && deltaX >= -100:
						if deltaY >= -distance && deltaY < 0:
							finalIcon = icon
							obstaclePosition = icon.position
			elif direction == Vector2.LEFT:
				if currentDeltaX < deltaX:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX >= -distance && deltaX < 0:
						if deltaY <= 100 && deltaY >= -100:
							finalIcon = icon
							obstaclePosition = icon.position
			elif direction == Vector2.RIGHT:
				if currentDeltaX < deltaX:
					deltaX = currentDeltaX
					deltaY = currentDeltaY
					
					if deltaX <= distance && deltaX > 0:
						if deltaY <= 100 && deltaY >= -100:
							finalIcon = icon
							obstaclePosition = icon.position
				
	if finalIcon != null:
		finalIcon.queue_free()
				
	return obstaclePosition

func _physics_process(delta):
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if direction != Vector2.ZERO:
		lastDirection = direction
	
	if Input.is_action_just_pressed("initial_position"):
		player.position = initPosition
	
	if Input.is_action_just_released("confirm"):
		if lastDirection == Vector2.DOWN:
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.DOWN)
			
			if obstaclePosition != Vector2.ZERO:
				print("Up!")
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.RIGHT:
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.RIGHT)
			
			if obstaclePosition != Vector2.ZERO:
				print("Right!")
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.LEFT:
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.LEFT)
			
			if obstaclePosition != Vector2.ZERO:
				print("Left!")
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.UP:
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.UP)
			
			if obstaclePosition != Vector2.ZERO:
				print("Down!")
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
