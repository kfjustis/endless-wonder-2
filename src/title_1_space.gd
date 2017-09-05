
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)

func _process(delta):
	# change this to handle pause and menu blah
	if (Input.is_action_pressed("close_game")):
		load_next_scene()

func load_next_scene():
	get_tree().change_scene("title_1_jobs.tscn")


