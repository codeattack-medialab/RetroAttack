extends Node

export (PackedScene) var Passerby
export (PackedScene) var Mov_evil
export (PackedScene) var Stone

var mov_array := []
var chg_lin = 0
var mov_array_full := false setget ,get_mov_array_full

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Cambia de juego al hacer click con el ratón. Es un ejemplo, la
			# llamada a next_game tendría que ser cuando el juego termina.
			#Global.next_game()
			pass

func get_mov_array_full():
	return mov_array_full
	pass


func _ready():
	$Road.playing = true
	$Biker.transform_node($Positions/PosBiker.position)
	$MovEvilAnimatedSprite.hide()
	randomize()

	
func _on_TimerLaunchPasserby_timeout():
	var side = "Left" if bool(randi() % 2) else "Right"
	var position_from = get_node("Positions/%sFrom" % side).global_position
	var position_to = get_node("Positions/%sTo" % side).global_position
		
	var new_passerby = Passerby.instance()
	new_passerby.transform_node(position_to - position_from,position_from)
	get_parent().add_child(new_passerby)


func _on_TimerLaunchMovEvil_timeout():
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadTop.curve.get_baked_length())) 
	$Path/Path2DRoadDown/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadDown.curve.get_baked_length()))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	if mov_array.size() != 0:
		$MovEvilAnimatedSprite.play("ThrowLightningEyes")
		mov_array[0].show()
		mov_array.pop_front().transform_node(position_to-position_from,position_from,position_to)
#	var new_mov_evil = Mov_evil.instance()
#	new_mov_evil.transform_node(position_to-position_from,position_from,position_to)
#	get_parent().add_child(new_mov_evil)


func _on_TimerLaunchStone_timeout():
	var longTop = $Path/Path2DRoadTop.curve.get_baked_length()
	var LongDown = $Path/Path2DRoadDown.curve.get_baked_length()
	var proporcion = LongDown/longTop
	
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int(longTop)) 
	
	$Path/Path2DRoadDown/PathFollow2D.set_offset(int($Path/Path2DRoadTop/PathFollow2D.offset * proporcion))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	
	var new_stone = Stone.instance()
	new_stone.transform_node(position_to-position_from,position_from,position_to)
	get_parent().add_child(new_stone)
	pass # Replace with function body.
	
func get_PosMovCollage_position():
	#return $MovEvilAnimatedSprite.position
	return $Positions/PosMovCollage.position
	

func build_mov_collage(pos_from):
	var position_to : Vector2
	if mov_array.size() == 12: 
		mov_array_full = true
		create_final_enemy()
		return
	if mov_array.size() == 0:
		position_to = $Positions/PosMovCollage.position
		chg_lin = 0
	else:
		position_to = mov_array.back().destination
		var lin = int(mov_array.size() /3)
		if chg_lin != lin:
			chg_lin = lin
			position_to.x = $Positions/PosMovCollage.position.x
			position_to.y += 16 #* lin 
		else:
			position_to.x += 12
		
		
	var position_from =  pos_from
	#var position_to =  get_tree().get_root().get_node("Game3").get_PosMovCollage_position()
	var new_mov_evil = Mov_evil.instance()
	new_mov_evil.set_hit(true)
	new_mov_evil.transform_node(position_to-position_from,position_from,position_to)
	#if mov_array.size() == 0:
	mov_array.append(new_mov_evil)
	$MovEvilContainer.add_child(new_mov_evil)
	
	#get_tree().get_root().get_node("Game3/MovEvilContainer").add_child(new_mov_evil)
	
	#get_parent().add_child(new_mov_evil)
	pass
	
func create_final_enemy():
	$TimerLaunchPasserby.stop()
	$TimerLaunchStone.stop()
	$MovEvilAnimatedSprite.show()
	$MovEvilAnimatedSprite.play("Splash")
	$TimerLaunchMovEvil.start()
	for mov in mov_array:
		mov.hit = false
		mov.hide()


func _on_MovEvilAnimatedSprite_frame_changed():
	if $MovEvilAnimatedSprite.animation == "Splash":
		if $MovEvilAnimatedSprite.frame == 7 :
			#$MovEvilContainer.hide()
			for mov in mov_array:
				mov.hit = false
				mov.hide()
			
		


func _on_MovEvilAnimatedSprite_animation_finished():
	if $MovEvilAnimatedSprite.animation == "Splash":
		$MovEvilAnimatedSprite.play("Electric")
	elif $MovEvilAnimatedSprite.animation == "Electric":
		$MovEvilAnimatedSprite.play("StandBy")
	pass
