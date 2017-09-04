extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var screen_res = Vector2(Globals.get("display/width"), Globals.get("display/height"))

# scene objects
onready var bg = get_node("bg")
onready var slide_left = get_node("dark_left")
onready var slide_right = get_node("dark_right")
onready var timer = get_node("hand_timer")

# setup hand
onready var hand = get_node("hand")
var hand_end_pos = Vector2(0,0)
var hand_up_pos = Vector2(0,0)

# scene controls
var player_control = false
var can_timer = false

# constants
var SLIDE_OFFSET = 10.0  # this is how much it jumps per punch
var SLIDE_SHIFT = 20.0   # this one is for going back inwards
var HAND_DELAY = 0.2

func _ready():
	# setup background
	bg.set_size(screen_res)
	
	# setup shades
	var shade_size = Vector2(screen_res.x/2, screen_res.y)
	var shade_left_pos = Vector2(0,0)
	var shade_right_pos = Vector2(screen_res.x/2, 0)
	slide_left.set_size(shade_size)
	slide_right.set_size(shade_size)
	slide_right.set_pos(shade_right_pos)
	
	# setup timer
	timer.set_wait_time(HAND_DELAY)
	timer.connect("timeout", self, "timeout_callback")
	can_timer = true
	
	set_process(true)

func _process(delta):
	# handle escape
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()
	
	# handle player control and shades debounce
	if (Input.is_key_pressed(KEY_UP) && player_control):
		hand.set_pos(hand_up_pos)
		if (can_timer):
			can_timer = false
			timer.start()
	else:
		hand.set_pos(hand_end_pos)

	# slowly close shades for effect
	if (slide_left.get_pos().x < 0):
		slide_left.set_pos(Vector2(slide_left.get_pos().x + SLIDE_SHIFT * get_process_delta_time(), 0))
	if (slide_right.get_pos().x > screen_res.x/2):
		slide_right.set_pos(Vector2(slide_right.get_pos().x - SLIDE_SHIFT * get_process_delta_time(), 0))
	
	# check shades to trigger end scene

func timeout_callback():
	handle_shades()
	timer.stop()
	can_timer = true

func handle_shades():
	print("called shades")
	var new_left = Vector2(slide_left.get_pos().x - SLIDE_OFFSET, slide_left.get_pos().y)
	var new_right = Vector2(slide_right.get_pos().x + SLIDE_OFFSET, slide_right.get_pos().y)
	slide_left.set_pos(new_left)
	slide_right.set_pos(new_right)

func end_animation():
	# store where the hand ends up
	hand_end_pos = hand.get_pos()
	# store where the hand will go on key press
	var new_hand_pos = Vector2(hand.get_pos().x, hand.get_pos().y - 150.0)
	# set the global var
	hand_up_pos = (new_hand_pos)
	# give control to player
	#print("Giving player control...")
	player_control = true