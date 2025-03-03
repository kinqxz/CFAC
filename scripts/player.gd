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
	for obstacle in obstacles:
		if obstacle.name.substr(0, 4) == "Icon":
			var icon: Sprite2D = obstacle
			var deltaX = icon.position.x - playerX
			var deltaY = icon.position.y - playerY
			
			if direction == Vector2.UP:
				if deltaX <= 40 && deltaX >= -40:
					if deltaY <= 500 && deltaY > 0:
						return icon.position
			elif direction == Vector2.DOWN:
				if deltaX <= 40 && deltaX >= -40:
					if deltaY >= -500 && deltaY < 0:
						return icon.position
			elif direction == Vector2.LEFT:
				if deltaX >= -500 && deltaX < 0:
					if deltaY <= 40 && deltaY >= -40:
						return icon.position
			elif direction == Vector2.RIGHT:
				if deltaX <= 500 && deltaX > 0:
					if deltaY <= 40 && deltaY >= -40:
						return icon.position
				
	return Vector2.ZERO

func _physics_process(delta):
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if direction != Vector2.ZERO:
		lastDirection = direction
	
	if Input.is_action_just_pressed("initial_position"):
		player.position = initPosition
	
	if Input.is_action_just_released("confirm"):
		if lastDirection == Vector2.DOWN:
			print("Up!")
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.DOWN)
			
			if obstaclePosition != Vector2.ZERO:
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.RIGHT:
			print("Right!")
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.RIGHT)
			
			if obstaclePosition != Vector2.ZERO:
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.LEFT:
			print("Left!")
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.LEFT)
			
			if obstaclePosition != Vector2.ZERO:
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
		if lastDirection == Vector2.UP:
			print("Down!")
			var obstaclePosition = findObstacle(player.get_position_delta(), Vector2.UP)
			
			if obstaclePosition != Vector2.ZERO:
				player.position = obstaclePosition
				lastDirection = Vector2.ZERO
