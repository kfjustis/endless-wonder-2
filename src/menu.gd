
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

onready var screen_res = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var o_bg = get_node("options_bg")
onready var c_title = get_node("options_bg/title_container")
onready var t_title = get_node("options_bg/title_container/l_title")

# percent size of the main screen resolution
var SCREEN_RES_PERC = 0.75

var OBG_OPACITY = 0.75

func _ready():
	get_node("stream_player").play()
	setup_options()
	set_process(true)

func _process(delta):
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()

# styles the background/options stuff for the menu screen
func setup_options():
	# set size for the option bg frame
	var obg_size = Vector2(screen_res.x * SCREEN_RES_PERC, screen_res.y * SCREEN_RES_PERC)
	var obg_centered = Vector2((screen_res.x/2) - (obg_size.x/2), (screen_res.y/2) - (obg_size.y/2))
	o_bg.set_size(obg_size)
	o_bg.set_pos(obg_centered)
	
	# set text options
	var title_centered = Vector2((o_bg.get_size().x/2) - (c_title.get_size().x/2), (o_bg.get_size().y/9) - (c_title.get_size().y/2))
	c_title.set_pos(title_centered)