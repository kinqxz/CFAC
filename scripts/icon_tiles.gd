extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

signal chosen
signal stopped

func _ready() -> void:
	chosen.connect(animate)
	stopped.connect(stopAnimation)

func animate() -> void:
	animation_player.play("chosen")
	
func stopAnimation() -> void:
	animation_player.stop()
