extends Node

export (PackedScene) var Passerby
export (PackedScene) var Obstacle
export (PackedScene) var Stone

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Cambia de juego al hacer click con el ratón. Es un ejemplo, la
			# llamada a next_game tendría que ser cuando el juego termina.
			#Global.next_game()
			pass

func _ready():
	$Road.playing = true
	$Biker.transform_node($Positions/PosBiker.position)
	randomize()
	
func _on_TimerLaunchPasserby_timeout():
	var side = "Left" if bool(randi() % 2) else "Right"
	var position_from = get_node("Positions/%sFrom" % side).global_position
	var position_to = get_node("Positions/%sTo" % side).global_position
		
	var new_passerby = Passerby.instance()
	new_passerby.transform_node(position_to - position_from,position_from)
	get_parent().add_child(new_passerby)


func _on_TimerLaunchObstacle_timeout():
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadTop.curve.get_baked_length())) 
	$Path/Path2DRoadDown/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadDown.curve.get_baked_length()))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	
	var new_obstacle = Obstacle.instance()
	new_obstacle.transform_node(position_to-position_from,position_from)
	get_parent().add_child(new_obstacle)


func _on_TimerLaunchStone_timeout():
	var longTop = $Path/Path2DRoadTop.curve.get_baked_length()
	var LongDown = $Path/Path2DRoadDown.curve.get_baked_length()
	var proporcion = LongDown/longTop
	
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int(longTop)) 
	
	$Path/Path2DRoadDown/PathFollow2D.set_offset(int($Path/Path2DRoadTop/PathFollow2D.offset * proporcion))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	
	var new_stone = Stone.instance()
	new_stone.transform_node(position_to-position_from,position_from)
	get_parent().add_child(new_stone)
	pass # Replace with function body.
	
func get_MovEvilAnimatedSprite_position():
	return $MovEvilAnimatedSprite.position

