extends AnimatedSprite2D

signal submerge
signal chosen
signal chosen_stop
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	submerge.connect(animateSubmerge)
	chosen.connect(animateChosen)
	chosen_stop.connect(stopAnimation)
	
func animateSubmerge() -> void:
	play("submerge")
	
func animateChosen() -> void:
	animation_player.play("chosen")
	
func stopAnimation() -> void:
	animation_player.stop()
	

func _on_animation_finished() -> void:
	queue_free()
