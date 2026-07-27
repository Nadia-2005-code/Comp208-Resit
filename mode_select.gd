extends Control

@onready var vButton = $VBoxContainer/vButton
@onready var tournamentButton = $VBoxContainer/TournamentButton

func _ready() -> void:
	vButton.pressed.connect(func(): get_tree().change_scene_to_file("res://oneVsOne.tscn"))
	tournamentButton.pressed.connect(func(): get_tree().change_scene_to_file("res://tournament_setup.tscn"))
