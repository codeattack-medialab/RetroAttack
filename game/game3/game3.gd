extends Node

export (PackedScene) var passerby

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Cambia de juego al hacer click con el ratón. Es un ejemplo, la
			# llamada a next_game tendría que ser cuando el juego termina.
			Global.next_game()

func _ready():
	$Road.playing = true
	


func _on_TimerLaunchPasserby_timeout():
	
	var new_passerby = passerby.instance() # si haces un preload, se carga al instanciar
		
	#yield(get_tree().create_timer(0.5), "timeout")
	
	new_passerby.launch_passerby(randi() % 2)
	get_parent().add_child(new_passerby)

	
