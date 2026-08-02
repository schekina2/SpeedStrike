extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var how_to_play_button = $VBoxContainer/HowToPlayButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var mute_button = $VBoxContainer/MuteButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	mute_button.pressed.connect(_on_mute_pressed)
	update_mute_button()

func _on_mute_pressed():
	SoundManager.toggle_mute()
	update_mute_button()

func update_mute_button():
	mute_button.text = "🔇 Sound off" if SoundManager.is_muted else "🔊 Sound on"
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")

func _on_quit_pressed():
	get_tree().quit()
