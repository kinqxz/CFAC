extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@onready var obstaclesNode: Node = $"../Obstacles"

#const SPEED = 300.0
var initPosition : Vector2 = Vector2(184.0, 152.0)
var jumpingDistance : float = 16.0
var lastDirection : Vector2 = Vector2.ZERO
var lastObstacleFound : AnimatedSprite2D = null
var obstacleFound : AnimatedSprite2D = null
#const JUMP_VELOCITY = -400.0
#var health = 100.0

func move(to: Vector2) -> void:
	var animation = $AnimatedSprite2D/AnimationPlayer.get_animation("move")
	var track = animation.find_track("AnimatedSprite2D:position", Animation.TYPE_VALUE)
	var first_key = animation.track_get_key_count(track) - 2
	var last_key = animation.track_get_key_count(track) - 1
	
	var x = -(player.position.x - to.x)
	var y = -(player.position.y - to.y)
	
	animation.track_set_key_value(track, first_key, Vector2.ZERO)
	animation.track_set_key_value(track, last_key, Vector2(x,y))
	$AnimatedSprite2D/AnimationPlayer.play("move")
	player.position = to
	
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
							if currentDeltaY < deltaY:
								deltaX = currentDeltaX
								deltaY = currentDeltaY
								
								if deltaX == 0:
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

func _physics_process(delta):
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	
	if direction != Vector2.ZERO:
		if lastDirection != direction:
			lastDirection = direction
			
			if obstacleFound != null:
				obstacleFound.emit_signal("chosen_stop")
	
	if Input.is_action_just_released("initial_position"):
		player.position = initPosition
		animated_sprite_2d.play("jump_right")
	
	if Input.is_action_just_released("confirm"):
		if obstacleFound != null:
			move(obstacleFound.position)
			
			if lastObstacleFound != null:
				lastObstacleFound.emit_signal("submerge")
			
			lastObstacleFound = obstacleFound
			obstacleFound = null
			
	if direction != Vector2.ZERO:
		if lastDirection == Vector2.DOWN:
			#This is actually up its just that the vectors are confusing
			animated_sprite_2d.play("look_up")
			var obstacle = findObstacle(player.get_position_delta(), Vector2.DOWN)
			
			if obstacle != null:
				print("Up!")
				lastDirection = Vector2.ZERO
				obstacle.emit_signal("chosen")
				obstacleFound = obstacle
		if lastDirection == Vector2.RIGHT:
			animated_sprite_2d.play("look_right")
			var obstacle = findObstacle(player.get_position_delta(), Vector2.RIGHT)
				
			if obstacle != null:
				print("Right!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
		if lastDirection == Vector2.LEFT:
			animated_sprite_2d.play("look_left")
			var obstacle = findObstacle(player.get_position_delta(), Vector2.LEFT)
				
			if obstacle != null:
				print("Left!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
		if lastDirection == Vector2.UP:
			#This is actually down
			animated_sprite_2d.play("look_down")
			var obstacle = findObstacle(player.get_position_delta(), Vector2.UP)
			
			if obstacle != null:
				print("Down!")
				obstacle.emit_signal("chosen")
				lastDirection = Vector2.ZERO
				obstacleFound = obstacle
