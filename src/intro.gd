
extends Control

var opening = true;

func _ready():
	set_process(true)

func _process(delta):
	if (Input.is_action_pressed("close_game") and !opening):
		get_tree().quit()
	elif (Input.is_action_pressed("close_game") and opening):
		get_tree().change_scene("menu.tscn")

func load_menu():
	get_tree().change_scene("menu.tscn")

func play_hard_open():
	get_node("player").play("hard_open")

func play_bg_music():
	get_node("player").play("opening_bgm_perf")

func stop_bg_music():
	get_node("player").stop_all()
