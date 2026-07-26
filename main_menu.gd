extends Control

@onready var player1Name = $VBoxContainer/Player1NameInput
@onready var player2Name = $VBoxContainer/Player2NameInput
@onready var playButton = $VBoxContainer/PlayButton

func _ready() -> void:
	playButton.pressed.connect(on_play_pressed)

func on_play_pressed() -> void:
	var name1 = player1Name.text.strip_edges()
	var name2 = player2Name.text.strip_edges()
	GameState.player1Name = name1 if name1 != "" else "Red"
	GameState.player2Name = name2 if name2 != "" else "Yellow"
	get_tree().change_scene_to_file("res://Main.tscn")
