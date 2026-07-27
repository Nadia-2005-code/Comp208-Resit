extends Node

@export var red_token_scene: PackedScene
@export var yellow_token_scene: PackedScene
@onready var boardNode = $Board
@onready var GameOver = $GameOverMenu
@onready var mainMenuButton = $SidePanel/ScorePanel/MainMenuButton
@onready var redScore = $SidePanel/ScorePanel/RedScore
@onready var yellowScore = $SidePanel/ScorePanel/YellowScore

var playableSize: float
var boardSize: int
var boardHeight: int
var columnWidth: float
var rowHeight: float
var player: int
var winner: int
var boardData: Array[Array]
var columnFill: Array[int]
var movesCount: int
var marginSize: int = 50
var boardStart_x: float
var boardStart_y: float
var adjusted_x: float
var isDropping: bool = false

func _ready() -> void:
	boardSize = boardNode.texture.get_width()
	boardHeight = boardNode.texture.get_height()
	playableSize = boardSize - (marginSize*2)
	columnWidth = playableSize / 7
	boardStart_x = boardNode.global_position.x
	boardStart_y = boardNode.global_position.y
	var playableHeight = boardHeight - (marginSize*2)
	rowHeight = playableHeight / 6.0
	new_game()
	GameOver.restart.connect(_on_game_over_menu_restart)
	GameOver.MainMenu.connect(_on_main_menu_pressed)
	mainMenuButton.pressed.connect(_on_main_menu_pressed)
	update_score_number()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			adjusted_x = event.position.x - boardStart_x - marginSize
			var col = floor(adjusted_x / columnWidth)
			col = clamp(col, 0, 6)
			if winner == 0 and columnFill[col] < 6 and not isDropping:
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
	GameOver.hide()


func drop_piece(col):
	isDropping = true
	var row = 5 - columnFill[col]
	boardData[row][col] = player
	columnFill[col] += 1
	movesCount += 1
	var tween = create_marker(col, row)
	await tween.finished
	var winData = check_winner()
	winner = winData[0]       
	var winCoords = winData[1]
	if winner != 0:
		winAnimation(winCoords)
		get_tree().paused = true
		await get_tree().create_timer(0.6).timeout
		GameOver.show()
		var winnerName = GameState.player1Name if winner == 1 else GameState.player2Name
		if TournamentState.inProgress:
			handle_tournament_win(winnerName)
		else:
			if winner == 1:
				GameState.player1Wins += 1
				GameOver.get_node("ResultLabel").text = GameState.player1Name + " wins!!"
			elif winner == -1:
				GameState.player2Wins += 1
				GameOver.get_node("ResultLabel").text = GameState.player2Name + " wins!!"
			update_score_number()
	elif movesCount == 42:
		get_tree().paused = true
		GameOver.show()
		GameOver.get_node("ResultLabel").text = "It's a draw!!"
	else:
		player *= -1 
		isDropping = false 


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
	var spawn_y = topHole_y - 100
	token.global_position = Vector2(pos_x, spawn_y)
	var tween = get_tree().create_tween()
	var bounceHeight = randi_range(12, 18)
	tween.tween_property(token, "global_position", Vector2(pos_x, pos_y), 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(token, "global_position", Vector2(pos_x, pos_y - bounceHeight), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(token, "global_position", Vector2(pos_x, pos_y), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	return tween

func check_winner() -> Array:
	# Check horizontal (-)
	for r in range(6):
		for c in range(4):
			var total = boardData[r][c] + boardData[r][c+1] + boardData[r][c+2] + boardData[r][c+3]
			if abs(total) == 4: 
				return [boardData[r][c], [Vector2(r,c), Vector2(r,c+1), Vector2(r,c+2), Vector2(r,c+3)]]

	# Check vertical (|)
	for c in range(7):
		for r in range(3):
			var total = boardData[r][c] + boardData[r+1][c] + boardData[r+2][c] + boardData[r+3][c]
			if abs(total) == 4: 
				return [boardData[r][c], [Vector2(r,c), Vector2(r+1,c), Vector2(r+2,c), Vector2(r+3,c)]]

	# Check diagonal down-right (\)
	for r in range(3):
		for c in range(4):
			var total = boardData[r][c] + boardData[r+1][c+1] + boardData[r+2][c+2] + boardData[r+3][c+3]
			if abs(total) == 4: 
				return [boardData[r][c], [Vector2(r,c), Vector2(r+1,c+1), Vector2(r+2,c+2), Vector2(r+3,c+3)]]

	# Check diagonal up-right (/)
	for r in range(3, 6):
		for c in range(4):
			var total = boardData[r][c] + boardData[r-1][c+1] + boardData[r-2][c+2] + boardData[r-3][c+3]
			if abs(total) == 4: 
				return [boardData[r][c], [Vector2(r,c), Vector2(r-1,c+1), Vector2(r-2,c+2), Vector2(r-3,c+3)]]

	# No winner yet: return 0 and an empty array
	return [0, []]

func _on_game_over_menu_restart():
	get_tree().paused = false
	if TournamentState.inProgress and not TournamentState.is_tournament_complete():
		var pair = TournamentState.get_match_players(TournamentState.currentMatchIndex)
		GameState.player1Name = pair[0]
		GameState.player2Name = pair[1]
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().paused = false 
	TournamentState.in_progress = false
	get_tree().change_scene_to_file("res://mode_select.tscn")

func winAnimation(winCoords):
	for coord in winCoords:
		var r = coord.x
		var c = coord.y
		var pos_x = boardStart_x + marginSize + (c * columnWidth) + (columnWidth / 2.0)
		var verticalGap = columnWidth + 10
		var topHole_y = boardStart_y + 100
		var pos_y = topHole_y + (r * verticalGap)
		var pulseToken
		if winner == 1:
			pulseToken = red_token_scene.instantiate()
		else:
			pulseToken = yellow_token_scene.instantiate()
		add_child(pulseToken)
		pulseToken.global_position = Vector2(pos_x, pos_y)
		pulseToken.z_index = 5
		pulseToken.process_mode = Node.PROCESS_MODE_ALWAYS
		var pulse = pulseToken.create_tween().set_loops()
		pulse.tween_property(pulseToken, "scale", Vector2(1.3, 1.3), 0.2).set_trans(Tween.TRANS_SINE)
		pulse.tween_property(pulseToken, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE)

func update_score_number():
	redScore.text = "Red: " + str(GameState.player1Wins)
	yellowScore.text = "Yellow: " + str(GameState.player2Wins)


func _on_change_name_button_pressed() -> void:
	get_tree().change_scene_to_file("res://oneVsOne.tscn")

func handle_tournament_win(winnerName: String) -> void:
	TournamentState.record_winner(winnerName)
	if TournamentState.is_tournament_complete():
		GameOver.get_node("ResultLabel").text = winnerName + " is the Tournament Champion!!"
		GameOver.get_node("Restart").visible = false
	else:
		var round_name = TournamentState.get_round_name(TournamentState.currentMatchIndex)
		GameOver.get_node("ResultLabel").text = winnerName + " wins the " + round_name + "!"
		GameOver.get_node("Restart").text = "Next Match"
