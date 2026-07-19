extends Node

@export var red_token_scene: PackedScene
@export var yellow_token_scene: PackedScene

var playableSize: float
var boardSize: int
var boardHeight: int
var columnWidth: float
var rowHeight: float
var player: int
var winner: int
var boardData: Array
var columnFill: Array
var movesCount: int
var marginSize: int = 50
var boardStart_x: float
var boardStart_y: float
var adjusted_x: float

func _ready() -> void:
	boardSize = $Board.texture.get_width()
	boardHeight = $Board.texture.get_height()
	playableSize = boardSize - (marginSize*2)
	columnWidth = playableSize / 7
	boardStart_x = $Board.global_position.x
	boardStart_y = $Board.global_position.y
	var playableHeight = boardHeight - (marginSize*2)
	rowHeight = playableHeight / 6.0
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
	var row = 5 - columnFill[col]
	boardData[row][col] = player
	columnFill[col] += 1
	movesCount += 1
	create_marker(col, row)
	player *= -1
	print(boardData)

func create_marker(col, row):
	var token
	if player == 1:
		token = red_token_scene.instantiate()
	else:
		token = yellow_token_scene.instantiate()
	add_child(token)
	var pos_x = boardStart_x + marginSize + (col * columnWidth) + (columnWidth / 2.0)
	var verticalGap = columnWidth + 10
	var topHole_y = boardStart_y + 100
	var pos_y = topHole_y + (row * verticalGap)
	token.global_position = Vector2(pos_x, pos_y)
