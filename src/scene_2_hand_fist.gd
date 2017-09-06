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

# setup audio
var rand_choice = 0 # points at the random audio piece we want to play for punch fx
var current_audio_str = ""

# scene controls
var movie_playing = true
var final_movie_playing = false
var player_control = false
var can_play_sound = false
var can_timer = false

# constants
var SLIDE_OFFSET = 15.0    # this is how much it jumps per punch # 10 is final, 30 is debug
var SLIDE_SHIFT = 20.0     # this one is for going back inwards
var SLIDE_SHIFT_END = 30.0 # for end cutscene
var HAND_SHIFT_END = 100.0
var HAND_DELAY = 0.2

func _ready():
	# setup hand (otherwise it appears for 1 frame when the scene loads)
	hand.set_pos(Vector2(screen_res.x * 2, screen_res.y * 2))
	
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
	set_process_input(true)

func _process(delta):
	# handle escape
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()
	
	# handle audio reset
	if (!get_node("hand_fx").is_active()):
		can_play_sound = true

	# slowly close shades for effect
	if (!movie_playing):
		if (slide_left.get_pos().x < 0):
			slide_left.set_pos(Vector2(slide_left.get_pos().x + SLIDE_SHIFT * get_process_delta_time(), 0))
		if (slide_right.get_pos().x > screen_res.x/2):
			slide_right.set_pos(Vector2(slide_right.get_pos().x - SLIDE_SHIFT * get_process_delta_time(), 0))
	
	# check shades to trigger end scene
	if (slide_left.get_pos().x + slide_left.get_size().x < screen_res.x/5):
		# play the jobs animation :)
		final_movie_playing = true
		movie_playing = true
		player_control = false
		if (slide_left.get_pos().x + slide_left.get_size().x > 0):
			slide_left.set_pos(Vector2(slide_left.get_pos().x - SLIDE_SHIFT_END * get_process_delta_time(), 0))
			slide_right.set_pos(Vector2(slide_right.get_pos().x + SLIDE_SHIFT_END * get_process_delta_time(), 0))
		if (hand.get_pos().y < screen_res.y + screen_res.y * 0.75):
			hand.set_pos(Vector2(hand.get_pos().x, hand.get_pos().y + HAND_SHIFT_END * get_process_delta_time()))

func _input(event):
	# handle player input
	if (!movie_playing):
		if (event.type == InputEvent.KEY):
			# up was pressed and player has control
			if (event.scancode == KEY_UP && event.pressed == true && player_control):
				# move the hand
				hand.set_pos(hand_up_pos)
				# play sound effect with de-bounce
				if (!get_node("hand_fx").is_active() && can_play_sound):
					handle_punch_audio()
				# makes it so shades don't advance when key held down (I think)
				if (can_timer):
					can_timer = false
					timer.start()
				player_control = false
			# up was released
			elif event.scancode == KEY_UP && event.pressed == false:
				# return hand to starting pos
				hand.set_pos(hand_end_pos)
				player_control = true

func timeout_callback():
	handle_shades()
	timer.stop()
	can_timer = true

func handle_punch_audio():
	# lock sound playing
	can_play_sound = false
	# get random number
	randomize()
	rand_choice = randi() % 6 + 1 # want num from 1-6
	# load choice as current sound to play
	select_audio(rand_choice)
	# play sound
	get_node("hand_fx").play(current_audio_str)
	
# converts given integer to a specific audio file to play
func select_audio(number):
	if (number == 1):
		current_audio_str = "hurt1"
	elif (number == 2):
		current_audio_str = "hurt2"
	elif (number == 3):
		current_audio_str = "hurt3"
	elif (number == 4):
		current_audio_str = "hurt4"
	elif (number == 5):
		current_audio_str = "hurt5"
	elif (number == 6):
		current_audio_str = "hurt6"
	else:
		# just set it to a certain one by default (6 for sure lol)
		current_audio_str = "hurt6"

func handle_shades():
	# move the shades every time this is called
	var new_left = Vector2(slide_left.get_pos().x - SLIDE_OFFSET, slide_left.get_pos().y)
	var new_right = Vector2(slide_right.get_pos().x + SLIDE_OFFSET, slide_right.get_pos().y)
	slide_left.set_pos(new_left)
	slide_right.set_pos(new_right)

func end_animation():
	# store where the hand ends up
	hand_end_pos = hand.get_pos()
	# store where the hand will go on key press
	var new_hand_pos = Vector2(hand.get_pos().x, hand.get_pos().y - 150.0)
	# set the global var for where the "up" hand should be
	hand_up_pos = (new_hand_pos)
	# signal movie finished
	movie_playing = false
	# give control to player and allow sounds
	player_control = true
	can_play_sound = true