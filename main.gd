extends Node

var playableSize: float
var boardSize: int
var columnWidth: float
var gridPos: Vector2i
var player: int
var winner: int
var boardData: Array
var columnFill: Array
var movesCount: int
var marginSize: int = 50
var boardStart_x:int
var adjusted_x: int

func _ready() -> void:
	boardSize = $Board.texture.get_width()
	playableSize = boardSize - (marginSize*2)
	columnWidth = playableSize / 7
	var boardStart_x = $Board.global_position.x
	new_game()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			gridPos = Vector2i(event.position/columnWidth)
			adjusted_x = event.position.x - boardStart_x - marginSize
			var col = floor(adjusted_x / columnWidth)
			col = clamp(col, 0, 6)
			if col >= 0 and col < 7 and columnFill[col] < 6:
				columnFill[col] += 1
				print(columnFill)
		
func new_game():
	player = 1
	winner = 0
	boardData = [
		[0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0]
		]
	columnFill = [0,0,0,0,0,0,0]
	movesCount = 0
