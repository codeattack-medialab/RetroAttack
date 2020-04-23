extends Node

export (PackedScene) var Passerby
export (PackedScene) var Mov_evil
export (PackedScene) var Stone
export (PackedScene) var BuildingInd

var mov_array := []
var clear_array := []
var chg_lin = 0
var mov_array_full := false setget ,get_mov_array_full

var final = false
var countdown : int
var life : int

func get_mov_array_full():
	return mov_array_full



func _init():
	OS.center_window()  

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Cambia de juego al hacer click con el ratón. Es un ejemplo, la
			# llamada a next_game tendría que ser cuando el juego termina.
			#Global.next_game()
			pass
	#if event is InputEventAction:
	if event.is_action_pressed("ui_cancel"):
		todo_detenido()
		eliminar_instancias()


func _ready():
	
	todo_detenido()
	$Audio/MusicStart.play()
	randomize()

func _on_Hud_start_button():
	start()

func start():
	eliminar_instancias()
	countdown = 90
	life = 3
	final =false
	mov_array_full=false
	
	$Hud.set_life(str(life))
	$Hud.set_score(seconds_to_minute(countdown))
	$Hud.set_texto("¡¡ EMPEZAMOS !!")
	$TimerLaunchBuilding.emit_signal("timeout")
	$TimerLaunchBuilding.start()
	$Road.playing = true
	$FloorAnim.playing = true
	
	$TimerStartGame.start()
	
func eliminar_instancias():
	for node in clear_array:
		if is_instance_valid(node):
		#if node != $_NULL:
			if node.has_method("clear_node"):
				node.clear_node()
	clear_array.clear()
	mov_array.clear()
	
func _on_TimerStartGame_timeout():
	todo_en_movimiento()
	
func todo_en_movimiento():
	$Biker.transform_node($Positions/PosBiker.position)
	$Biker.set_game_over("no")
	$Biker.show()
	$TimerLaunchPasserby.start()
	$TimerLaunchStone.start()
	$TimerScore.start()
	
func todo_detenido():
	$Biker.hide()
	$Biker.set_game_over("pausado")
	$Road.playing = false
	$FloorAnim.playing = false
	$MovEvilAnimatedSprite.hide()
	$TimerLaunchPasserby.stop()
	$TimerLaunchStone.stop()
	$TimerLaunchBuilding.stop()
	$TimerLaunchMovEvil.stop()
	$TimerScore.stop()
	$Hud.start()
	

func _on_Biker_biker_end(game_over):
	end_game(game_over)

func end_game(game_over):
	if game_over == "good":
		$Hud.set_texto("¡Enhorabuena! Los MovEvil han sucumbido ")
	elif game_over == "bad":
		$Hud.set_texto("Los MovEvil han conquistado el mundo ¡Evitalo!")
	elif game_over == "time_up":
		$Hud.set_texto("Se acabo el tiempo ¡Intentalo de nuevo!")
	todo_detenido()







# Perseguir al Biker
func _on_MovEvil_end_street_follow_Biker(node):
	node.transform_node(node.global_position,$Biker.global_position,Vector2())

# Passerby recibe golpe de paper y lanza MovEvil
func _on_Passerby_readpaper_throw_MovEvil(pos,object):
	if !mov_array_full:
		build_mov_collage(pos)
	object.disconnect("throw_MovEvil",self,"_on_Passerby_readpaper_throw_MovEvil")


func build_mov_collage(pos_from):
	var position_to : Vector2
	
#	if mov_array.size() == 2: # PONER A 9!!!!
#		mov_array_full = true
#		create_final_enemy()
#		return
		
	if mov_array.size() == 0:
		position_to = $Positions/PosMovCollage.position
		chg_lin = 0
	else:
		position_to = mov_array.back().destination
		var lin = int(mov_array.size() /3)
		if chg_lin != lin:
			chg_lin = lin
			position_to.x = $Positions/PosMovCollage.position.x
			position_to.y += 17 
		else:
			position_to.x += 13
		
	var position_from =  pos_from 
	var position_to_shadow := Vector2(position_to.x,$Positions/PosMovCollageShadow.position.y)
	
	var new_mov_evil = Mov_evil.instance()
	mov_array.append(new_mov_evil)
	clear_array.append(new_mov_evil)
	new_mov_evil.set_hit(true)
	
	new_mov_evil.transform_node(position_from,position_to,position_to_shadow)
	
	new_mov_evil.connect("end_street",self,"_on_MovEvil_end_street_follow_Biker")
	# Lo hacemos mediante call_deferred, porque nos genera un error $MovEvilContainer.add_child(new_mov_evil)
	$MovEvilContainer.call_deferred("add_child",new_mov_evil)
	$MovEvilContainer.call_deferred("move_child",new_mov_evil,0)
	new_mov_evil.call_deferred("make_transparent_to_solid",0.1)
	
	
	## CUANDO EL ARRAY TENGA LOS ELEMENTOS DESEADOS PARAMOS
	## LAS PIEDRAS Y PASEANTES Y LANZAMOS EL ENEMIGO FINAL
	if mov_array.size() == 9: # PONER A 9!!!!
		mov_array_full = true
		$TimerLaunchPasserby.stop() # Paramos 
		$TimerLaunchStone.stop()
		$TimerLaunchMovEvilFinal.start()
		

func _on_TimerLaunchMovEvilFinal_timeout():
	create_final_enemy()

func create_final_enemy():
	make_transparent_movEvil()
	$MovEvilAnimatedSprite.show()
	$MovEvilAnimatedSprite.play("Splash")
	$TimerLaunchMovEvil.start()

func make_transparent_movEvil():
	var color_transparent:= Color(1,1,1,1) # Blanco sin transparencia
	
	while $MovEvilContainer.modulate.a >= 0:
		# la propiedadad Color.a es el canal alpha, con rango 0-1
		# Vamos disminuyendo su valor para hacer la trasnparencia
		# Y se lo pasamos a modulate del nodo que engloba los MovEvil
		color_transparent.a -= .1
		$MovEvilContainer.modulate = color_transparent
		yield(get_tree().create_timer(0.01), "timeout")
	
	for mov in mov_array:
				mov.set_hit(false) # Ocultamos a todos los MovEvil del array
				mov.hide()
	
	$MovEvilContainer.modulate = Color(1,1,1,1) # Quitamos la transparencia

func _on_TimerLaunchMovEvil_timeout():	
		$MovEvilAnimatedSprite.play("ThrowLightningEyes")
		$Audio/AudioMovEvilToAsphalt.play()


# Control de Animaciones del Jefe Final
func _on_MovEvilAnimatedSprite_animation_finished():
	if $MovEvilAnimatedSprite.animation == "Splash":
		if final:
			$MovEvilAnimatedSprite.hide()
			$Biker.set_game_over("good")
			$Biker.ending($Positions/PosBikerFinal.position)
		else:
			$MovEvilAnimatedSprite.play("Electric")
			#$Audio/AudioNeutron.play()
	elif $MovEvilAnimatedSprite.animation == "Electric":
		$MovEvilAnimatedSprite.play("StandBy")
	elif $MovEvilAnimatedSprite.animation == "ThrowLightningEyes":
		MovEvilAttack()
		$MovEvilAnimatedSprite.play("StandBy")
	elif $MovEvilAnimatedSprite.animation == "LightningEyes":
		$MovEvilAnimatedSprite.play("LightningEyesElectric")
		
	elif $MovEvilAnimatedSprite.animation == "LightningEyesElectric":
		$Audio/AudioMovEvilFinalDestroy.play()
		$MovEvilAnimatedSprite.play("Splash",true)
	else:
		$MovEvilAnimatedSprite.play("StandBy")

func MovEvilAttack():
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadTop.curve.get_baked_length())) 
	$Path/Path2DRoadDown/PathFollow2D.set_offset(randi() % int($Path/Path2DRoadDown.curve.get_baked_length()))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	if mov_array.size() != 0:
		mov_array[0].show()
		mov_array[0].make_transparent_to_solid(0.1)
		mov_array.pop_front().transform_node(position_from,position_to,Vector2())
	else:
		# MoveEvilFinal ¡¡DESTROY!!
		#### DESTRUIR CUANDO NO QUEDEN MOVEVIL EN EL CONTENEDOR ####
		if $MovEvilContainer.get_child_count() == 0:
			$TimerLaunchMovEvil.stop()
			$MovEvilAnimatedSprite.stop()
			yield(get_tree().create_timer(1.0), "timeout")
			$MovEvilAnimatedSprite.play("LightningEyes")
			final=true




func _on_Biker_hit():
	life -= 1
	$Hud.set_life(life)
	if life == 0:
		$Biker.set_game_over("bad")
		end_game("bad")
		$TimerScore.stop()
		

func _on_TimerScore_timeout():
	countdown -= 1
	$Hud.set_score(seconds_to_minute(countdown))
	if countdown == 0:
		end_game("time_up")
	
func seconds_to_minute(time : int):
	var minutos := int(time/60)
	var segundos := int(time%60)
	var hora := String(str(minutos) + str(":%02d" % segundos))
	return hora
#print("%010d" % 12345)
## output: "0000012345"




func _on_TimerLaunchBuilding_timeout():
	# Lanzamos edificios en ambos lados
	for side in["Left","Right"]:
		var position_from = get_node("Positions/%sFromBuilding" % side).global_position
		var position_to = get_node("Positions/%sToBuilding" % side).global_position
			
		var new_building = BuildingInd.instance()
		clear_array.append(new_building)
		
		new_building.transform_node(position_to-position_from,position_from,side)
		$BuildingContainer.add_child(new_building)
		$BuildingContainer.move_child(new_building,0)
		new_building.make_transparent_to_solid(0.1)
	
func _on_TimerLaunchPasserby_timeout():
	var side = "Left" if bool(randi() % 2) else "Right"
	var position_from = get_node("Positions/%sFrom" % side).global_position
	var position_to = get_node("Positions/%sTo" % side).global_position
		
	var new_passerby = Passerby.instance()
	clear_array.append(new_passerby)
	new_passerby.transform_node(position_to - position_from,position_from,side)
	new_passerby.connect("throw_MovEvil",self,"_on_Passerby_readpaper_throw_MovEvil")
		
	$PasserbyContainer.add_child(new_passerby)
	$PasserbyContainer.move_child(new_passerby,0)
	new_passerby.make_transparent_to_solid(0.1)
	
func _on_TimerLaunchStone_timeout():
	var longTop = $Path/Path2DRoadTop.curve.get_baked_length()
	var LongDown = $Path/Path2DRoadDown.curve.get_baked_length()
	var proporcion = LongDown/longTop
	
	$Path/Path2DRoadTop/PathFollow2D.set_offset(randi() % int(longTop)) 
	
	$Path/Path2DRoadDown/PathFollow2D.set_offset(int($Path/Path2DRoadTop/PathFollow2D.offset * proporcion))
	var position_from =  $Path/Path2DRoadTop/PathFollow2D.global_position
	var position_to =  $Path/Path2DRoadDown/PathFollow2D.global_position
	
	var new_stone = Stone.instance()
	clear_array.append(new_stone)
	new_stone.transform_node(position_to-position_from,position_from,position_to)
	$StoneContainer.add_child(new_stone)
	$StoneContainer.move_child(new_stone,0)
	new_stone.make_transparent_to_solid(0.1)
	
	
func make_transparent_to_solid_node(nodo):
	var color_transparent:= Color(1,1,1,0) # Blanco con transparencia
	
	while nodo.modulate.a <= 1:
		# la propiedadad Color.a es el canal alpha, con rango 0-1
		# Vamos disminuyendo su valor para hacer la trasnparencia
		# Y se lo pasamos a modulate del nodo que engloba los MovEvil
		color_transparent.a += .1
		nodo.modulate = color_transparent
		yield(get_tree().create_timer(0.01), "timeout")

	
	nodo.modulate = Color(1,1,1,1) # Quitamos la transparencia




	
