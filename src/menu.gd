
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("stream_player").play()
	set_process(true)

func _process(delta):
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()
