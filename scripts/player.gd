extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@onready var obstaclesNode: Node = $"../Obstacles"
@onready var lilypad_one: AnimatedSprite2D = $"../Obstacles/Lilypads/Lilypad"

#const SPEED = 300.0
var initPosition : Vector2 = Vector2(184.0, 104.0)
var jumpingDistance : float = 16.0
var lastDirection : Vector2 = Vector2.ZERO
@onready var lastObstacleFound : AnimatedSprite2D = lilypad_one
var obstacleFound : AnimatedSprite2D = null
#const JUMP_VELOCITY = -400.0
#var health = 100.0

#func move(to: Vector2) -> void:
	#var animation = $AnimatedSprite2D/AnimationPlayer.get_animation("move")
	#var track = animation.find_track("AnimatedSprite2D:position", Animation.TYPE_VALUE)
	#var first_key = animation.track_get_key_count(track) - 2
	#var last_key = animation.track_get_key_count(track) - 1
	#
	#var x = -(player.position.x - to.x)
	#var y = -(player.position.y - to.y)
	#
	#animation.track_set_key_value(track, first_key, Vector2.ZERO)
	#animation.track_set_key_value(track, last_key, Vector2(x,y))
	#$AnimatedSprite2D/AnimationPlayer.play("move")
	#player.position = to
	
func findObstacle(playerPosition : Vector2, direction: Vector2) -> AnimatedSprite2D:
	#for number in range(1, 15):
		#print(number)
	var playerX = playerPosition.x
	var playerY = playerPosition.y
	
	var obstacles = obstaclesNode.get_children()
	var deltaX : float = jumpingDistance + 1
	var deltaY : float = jumpingDistance + 1
	var lastObstacle : AnimatedSprite2D = null
	
	for obstacle in obstacles:
		if obstacle.get_child_count() != 0:
			for child in obstacle.get_children():
				if child.name.substr(0, 7) == "Lilypad":
					if child is AnimatedSprite2D:
						var icon : AnimatedSprite2D = child
						var currentDeltaX = icon.position.x - playerX
						var currentDeltaY = icon.position.y - playerY
						
						if direction == Vector2.UP:
							if currentDeltaY <= deltaY && currentDeltaY > 0:
								deltaX = currentDeltaX
								deltaY = currentDeltaY
								
								if deltaX == 0:
									if deltaY <= jumpingDistance && deltaY > 0:
										lastObstacle = icon
						elif direction == Vector2.DOWN:
							print("why")
							if currentDeltaY < deltaY:
								print("hii")
								deltaX = currentDeltaX
								deltaY = currentDeltaY
								
								if deltaX == 0:
									print("hel")
									if deltaY >= (-1 * jumpingDistance) && deltaY < 0:
										lastObstacle = icon
						elif direction == Vector2.LEFT:
							if currentDeltaX < deltaX:
								deltaX = currentDeltaX
								deltaY = currentDeltaY
								
								if deltaX >= (-1 * jumpingDistance) && deltaX < 0:
									if deltaY == 0:
										lastObstacle = icon
						elif direction == Vector2.RIGHT:
							if currentDeltaX < deltaX && currentDeltaX > 0:
								deltaX = currentDeltaX
								deltaY = currentDeltaY
								
								if deltaX <= jumpingDistance && deltaX > 0:
									if deltaY == 0:
										lastObstacle = icon
	
	return lastObstacle

func checkPlayerRotation(direction : Vector2) -> void:
	if direction == Vector2.DOWN:
		if player.rotation_degrees != 0.0:
			player.rotation_degrees = 0.0
	elif direction == Vector2.UP:
		if player.rotation_degrees != 180.0:
			player.rotation_degrees = 180.0
	elif direction == Vector2.LEFT:
		if player.rotation_degrees != 270.0:
			player.rotation_degrees = 270.0
	elif direction == Vector2.RIGHT :
		if player.rotation_degrees != 90.0:
			player.rotation_degrees = 90.0

func _ready() -> void:
	player.position = initPosition

func _physics_process(delta):
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if direction != Vector2.ZERO:
		if lastDirection != direction:
			lastDirection = direction
			
			if obstacleFound != null:
				obstacleFound.emit_signal("chosen_stop")
	
	if Input.is_action_just_released("initial_position"):
		player.position = initPosition
	
	if Input.is_action_just_released("confirm"):
		if obstacleFound != null:
			if lastObstacleFound != null:
				lastObstacleFound.emit_signal("submerge")
			
			obstacleFound.emit_signal("chosen_stop")
			lastObstacleFound = obstacleFound
			player.position = obstacleFound.position
			obstacleFound = null
			
	if direction != Vector2.ZERO:
		if lastDirection == Vector2.DOWN:
			#This is actually up its just that the vectors are confusing
			checkPlayerRotation(Vector2.DOWN)
			var obstacle = findObstacle(player.get_position_delta(), Vector2.DOWN)
			
			if obstacle != null:
				print("Up!")
				lastDirection = Vector2.ZERO
				obstacle.emit_signal("chosen")
				obstacleFound = obstacle
		if lastDirection == Vector2.RIGHT:
			checkPlayerRotation(Vector2.RIGHT)
			var obstacle = findObstacle(player.get_position_delta(), Vector2.RIGHT)
				
			if obstacle != null:
				print("Right!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
		if lastDirection == Vector2.LEFT:
			checkPlayerRotation(Vector2.LEFT)
			var obstacle = findObstacle(player.get_position_delta(), Vector2.LEFT)
				
			if obstacle != null:
				print("Left!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
		if lastDirection == Vector2.UP:
			#This is actually down
			checkPlayerRotation(Vector2.UP)
			var obstacle = findObstacle(player.get_position_delta(), Vector2.UP)
			
			if obstacle != null:
				print("Down!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
