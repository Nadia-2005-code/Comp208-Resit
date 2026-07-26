extends CanvasLayer

signal restart
signal MainMenu

func _on_restart_pressed() -> void:
	restart.emit()
	
func _on_MainMenu_pressed() -> void:
	MainMenu.emit()
