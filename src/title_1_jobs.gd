extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var screen_res = Vector2(Globals.get("display/width"), Globals.get("display/height"))

onready var slide_left = get_node("dark_left")
onready var slide_right = get_node("dark_right")

# setup hand
onready var hand = get_node("hand")
# tested for this value
onready var hand_end_pos = Vector2(screen_res.x/2-hand.get_pos().x/4.0, screen_res.y-hand.get_pos().y/2 + 62.0)
var hand_dir = Vector2(0,0)

# scene controls
var player_control = false

func _ready():
	# setup shades
	var shade_size = Vector2(screen_res.x/2, screen_res.y)
	var shade_left_pos = Vector2(0,0)
	var shade_right_pos = Vector2(screen_res.x/2, 0)
	slide_left.set_size(shade_size)
	slide_right.set_size(shade_size)
	slide_right.set_pos(shade_right_pos)
	
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	# handle escape
	if (Input.is_action_pressed("close_game")):
		get_tree().quit()
	
	if (Input.is_key_pressed(KEY_UP)):
		print("-----> UP pressed")
		hand_dir = Vector2(hand_end_pos.x, hand_end_pos.y - 150.0)
	
	hand_dir = Vector2(hand_end_pos.x, hand_end_pos.y)
	
func _fixed_process(delta):
	# handle player
	if (player_control):
		print("Player has control")
		hand.set_pos(hand_dir)


func end_animation():
	player_control = true