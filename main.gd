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
			if winner == 0 and columnFill[col] < 6:
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
	winner = check_winner()
	if winner == 1:
		print("RED WINS!")
	elif winner == -1:
		print("YELLOW WINS!")
	elif movesCount == 42:
		print("It's a draw!")
	else:
		player *= -1 # Only swap turns if nobody won yet
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

func check_winner() -> int:
# Check horizontal (-)
	for r in range(6):
		for c in range(4):
			var total = boardData[r][c] + boardData[r][c+1] + boardData[r][c+2] + boardData[r][c+3]
			if abs(total) == 4: return boardData[r][c]

	# Check vertical (|)
	for c in range(7):
		for r in range(3):
			var total = boardData[r][c] + boardData[r+1][c] + boardData[r+2][c] + boardData[r+3][c]
			if abs(total) == 4: return boardData[r][c]

	# Check diagonal down-right (\)
	for r in range(3):
		for c in range(4):
			var total = boardData[r][c] + boardData[r+1][c+1] + boardData[r+2][c+2] + boardData[r+3][c+3]
			if abs(total) == 4: return boardData[r][c]

	# Check diagonal up-right (/)
	for r in range(3, 6):
		for c in range(4):
			var total = boardData[r][c] + boardData[r-1][c+1] + boardData[r-2][c+2] + boardData[r-3][c+3]
			if abs(total) == 4: return boardData[r][c]

	return 0 # No winner yet
