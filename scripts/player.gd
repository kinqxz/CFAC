extends CharacterBody2D

@onready var obstaclesNode: Node = get_node("../Obstacles")
@onready var lilypad_one: AnimatedSprite2D = get_node("../Obstacles/Lilypads/Lilypad")

var initPosition: Vector2 = Vector2(184.0, 104.0)
var jump_distance: float = 16.0
var last_obstacle: AnimatedSprite2D = lilypad_one
var selected_obstacle: AnimatedSprite2D = null
var move_delay: float = 0.5
var can_move: bool = true

func _ready() -> void:
	position = initPosition

func _physics_process(delta):
	if not can_move:
		return
	
	var direction = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if direction != Vector2.ZERO:
		selected_obstacle = find_obstacle(position, direction)
		if selected_obstacle:
			selected_obstacle.emit_signal("chosen")
	
	if Input.is_action_just_released("confirm") and selected_obstacle:
		move_to_obstacle(selected_obstacle)
		selected_obstacle = null
		can_move = false
		await get_tree().create_timer(move_delay).timeout
		can_move = true
	
	if Input.is_action_just_released("initial_position"):
		position = initPosition

func find_obstacle(start_position: Vector2, direction: Vector2) -> AnimatedSprite2D:
	var best_match: AnimatedSprite2D = null
	var min_distance = jump_distance + 1
	
	for obstacle in obstaclesNode.get_children():
		if obstacle.get_child_count() > 0:
			for child in obstacle.get_children():
				if child is AnimatedSprite2D and ("Lilypad" in child.name or child.name.begins_with("@")):
					var distance = (child.position - start_position).length()
					if distance <= jump_distance and direction.dot((child.position - start_position).normalized()) > 0.9:
						if distance < min_distance:
							min_distance = distance
							best_match = child
	return best_match

func move_to_obstacle(obstacle: AnimatedSprite2D) -> void:
	if last_obstacle:
		last_obstacle.emit_signal("submerge")
	
	position = obstacle.position
	obstacle.emit_signal("chosen_stop")
	last_obstacle = obstacle
	
	adjust_rotation(obstacle.position - position)

func adjust_rotation(direction: Vector2) -> void:
	if direction == Vector2.RIGHT:
		rotation_degrees = 90.0
	elif direction == Vector2.LEFT:
		rotation_degrees = 270.0
	elif direction == Vector2.UP:
		rotation_degrees = 180.0
	elif direction == Vector2.DOWN:
		rotation_degrees = 0.0
