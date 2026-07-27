extends Node

var players: Array[String] = []  
var winners: Array = [null, null, null, null, null, null, null]  
var currentMatchIndex: int = 0
var inProgress: bool = false

func start_tournament(names: Array[String]) -> void:
	players = names
	winners = [null, null, null, null, null, null, null]
	currentMatchIndex = 0
	inProgress = true

func get_match_players(matchIndex: int) -> Array:
	match matchIndex:
		0: return [players[0], players[1]]
		1: return [players[2], players[3]]
		2: return [players[4], players[5]]
		3: return [players[6], players[7]]
		4: return [winners[0], winners[1]]
		5: return [winners[2], winners[3]]
		6: return [winners[4], winners[5]]
	return ["", ""]

func get_round_name(matchIndex: int) -> String:
	if matchIndex <= 3:
		return "Quarterfinal"
	elif matchIndex <= 5:
		return "Semifinal"
	else:
		return "Final"

func record_winner(name: String) -> void:
	winners[currentMatchIndex] = name
	currentMatchIndex += 1

func is_tournament_complete() -> bool:
	return currentMatchIndex >= 7

func get_champion() -> String:
	return winners[6]
	
