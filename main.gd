extends Node

var boardSize: int
var columnWidth: int
var gridPos: Vector2i
var player: int
var winner: int



func _ready() -> void:
	boardSize = $board.texture.get_width()
	columnWidth = boardSize / 7

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			gridPos = Vector2i(event.position/columnWidth)
			print(gridPos)
		
		
func new_game():
	player = 1
	winner = 0
