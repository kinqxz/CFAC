extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100.0

func _physics_process(delta):
	var direction = Input.get_vector("look_left","look_right",
	"look_up","look_down")
	
	velocity = direction * SPEED
	move_and_slide()
