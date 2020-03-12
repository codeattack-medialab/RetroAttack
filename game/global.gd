extends Node

var current_game_idx := 0
var mlp_facade := false
var mlp_facade_size := Vector2(192, 157)
var do_mlp_facade := true
var saved_window_size: Vector2
var saved_window_position: Vector2
var game_list := []


func _init():
	randomize()

	var not_found := 0
	var game_id := 1
	while not_found < 20:
		if ResourceLoader.exists("res://game%d/game%d.tscn" % [game_id, game_id]):
			game_list.append(game_id)
			not_found = 0
		else:
			not_found += 1
		game_id += 1


func go_to_scene(new_scene):
	call_deferred("_deferred_go_to_scene", new_scene)


func _deferred_go_to_scene(new_scene):
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.free()
	current_scene = load(new_scene).instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)


func next_game():
	current_game_idx += 1
	if current_game_idx >= game_list.size():
		current_game_idx = 0
	var game_id: int = game_list[current_game_idx]
	go_to_scene("res://game%d/game%d.tscn" % [game_id, game_id])


func random_game():
	current_game_idx = randi() % game_list.size()
	var game_id: int = game_list[current_game_idx]
	go_to_scene("res://game%d/game%d.tscn" % [game_id, game_id])


func _unhandled_input(event):
	if event.is_action_pressed("toggle_mlp_facade") and do_mlp_facade:
		do_mlp_facade = false
		if mlp_facade:
			OS.window_borderless = false
			OS.window_position = saved_window_position
			OS.window_size = saved_window_size
			OS.window_resizable = true
			mlp_facade = false
		else:
			var window_offset := Vector2(40, 40)
			var screen_size := OS.get_screen_size()
			if screen_size == Vector2(1280, 1024):
				window_offset = Vector2(163, 142)
			OS.window_borderless = true
			saved_window_position = OS.window_position
			OS.window_position = window_offset
			saved_window_size = OS.window_size
			OS.window_size = mlp_facade_size
			OS.window_resizable = false
			mlp_facade = true
	elif event.is_action_released("toggle_mlp_facade"):
		do_mlp_facade = true
