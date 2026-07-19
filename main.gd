extends Node

var playableSize: float
var boardSize: int
var columnWidth: float
var player: int
var winner: int
var boardData: Array
var columnFill: Array
var movesCount: int
var marginSize: int = 50
var boardStart_x: float
var adjusted_x: float
var row: int

func _ready() -> void:
	boardSize = $Board.texture.get_width()
	playableSize = boardSize - (marginSize*2)
	columnWidth = playableSize / 7
	boardStart_x = $Board.global_position.x
	new_game()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			adjusted_x = event.position.x - boardStart_x - marginSize
			var col = floor(adjusted_x / columnWidth)
			col = clamp(col, 0, 6)
			if columnFill[col] < 6:
				drop_piece(col)
		
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
	
func drop_piece(col):
	row = 5 - columnFill[col]
	boardData[row][col] = player
	columnFill[col] += 1
	movesCount += 1
	player *= -1
	print(boardData)
	
