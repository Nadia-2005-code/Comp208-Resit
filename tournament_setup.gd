extends Control

@onready var nameInputs = [
	$CenterContainer/GridContainer/LineEdit,
	$CenterContainer/GridContainer/LineEdit2,
	$CenterContainer/GridContainer/LineEdit3,
	$CenterContainer/GridContainer/LineEdit4,
	$CenterContainer/GridContainer/LineEdit5,
	$CenterContainer/GridContainer/LineEdit6,
	$CenterContainer/GridContainer/LineEdit7,
	$CenterContainer/GridContainer/LineEdit8
]
@onready var startButton = $StartButton

func _ready() -> void:
	startButton.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	var names: Array[String] = []
	for i in range(8):
		var n = nameInputs[i].text.strip_edges()
		names.append(n if n != "" else "Player %d" % (i + 1))
	TournamentState.start_tournament(names)
	_load_current_match()

func _load_current_match() -> void:
	var pair = TournamentState.get_match_players(TournamentState.currentMatchIndex)
	GameState.player1Name = pair[0]
	GameState.player2Name = pair[1]
	get_tree().change_scene_to_file("res://Main.tscn")
