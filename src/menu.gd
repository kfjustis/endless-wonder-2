
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

# constants
# percent size of the main screen resolution
var SCREEN_RES_PERC = 0.75
var BUTTON_BG_PADDING = 0.80
# project screen resolution
onready var screen_res = Vector2(Globals.get("display/width"), Globals.get("display/height"))
# translucent background for menu items
onready var o_bg = get_node("options_bg")
# container for title text
onready var c_title = get_node("options_bg/title_container")
# container for menu items
onready var t_title = get_node("options_bg/title_container/l_title")

# menu items
# labels
onready var l_ng = get_node("options_bg/options_container/l_new_game")
onready var l_lg = get_node("options_bg/options_container/l_load_game")
onready var l_opts = get_node("options_bg/options_container/l_options")
onready var l_creds = get_node("options_bg/options_container/l_credits")
# buttons
onready var b_ng = get_node("options_bg/options_container/l_new_game/b_new_game")
onready var b_lg = get_node("options_bg/options_container/l_load_game/b_load_game")
onready var b_opts = get_node("options_bg/options_container/l_options/b_options")
onready var b_creds = get_node("options_bg/options_container/l_credits/b_credits")

func _ready():
	get_node("stream_player").play()
	# setup the menu graphics and styling
	setup_options()
	set_process(true)

func _process(delta):
	# handle escape
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()
	
	# handle menu items
	#if (check_mouse_bounds(n_ng)):
	#	print("MOUSE WAS OVER NEW GAME")

# styles the background/options stuff for the menu screen
func setup_options():
	# set size for the option bg frame
	var obg_size = Vector2(screen_res.x * SCREEN_RES_PERC, screen_res.y * SCREEN_RES_PERC)
	var obg_centered = Vector2((screen_res.x/2) - (obg_size.x/2), (screen_res.y/2) - (obg_size.y/2))
	o_bg.set_size(obg_size)
	o_bg.set_pos(obg_centered)
	
	# set text options
	# title
	var title_centered = Vector2((o_bg.get_size().x/2) - (c_title.get_size().x/2), (o_bg.get_size().y/9) - (c_title.get_size().y/2))
	c_title.set_pos(title_centered)
	# button labels
	# new game
	l_ng.set_size(l_ng.get_size() + l_ng.get_size() * BUTTON_BG_PADDING)
	b_ng.set_pos(l_ng.get_pos())
	b_ng.set_size(l_ng.get_size())
	b_ng.connect("pressed", self, "load_new_game")
	#l_ng.connect("pressed", self, "load_new_game")
	# load game
	l_lg.set_size(l_lg.get_size() + l_lg.get_size() * BUTTON_BG_PADDING)
	b_lg.set_pos(l_lg.get_pos() * l_ng.get_pos())
	b_lg.set_size(l_lg.get_size())
	# options
	l_opts.set_size(l_opts.get_size() + l_opts.get_size() * BUTTON_BG_PADDING)
	b_opts.set_pos(b_opts.get_pos() * l_ng.get_pos())
	b_opts.set_size(l_opts.get_size())
	# credits
	l_creds.set_size(l_creds.get_size() + l_creds.get_size() * BUTTON_BG_PADDING)
	b_creds.set_pos(b_creds.get_pos() * l_ng.get_pos())
	b_creds.set_size(l_creds.get_size())

func load_new_game():
	get_tree().change_scene("scene_1_space.tscn")