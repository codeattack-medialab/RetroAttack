extends Node


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Cambia de juego al hacer click con el ratón. Es un ejemplo, la
			# llamada a next_game tendría que ser cuando el juego termina.
			Global.next_game()
