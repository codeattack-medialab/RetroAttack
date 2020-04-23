extends Area2D

export (PackedScene) var Paper
export var speed = 50

signal hit
signal biker_end

var throwing := false
var player1 := 1
var player2 := 2

var position_start : Vector2
var position_limit_left = 19.0
var position_limit_right = 173.0
var position_end : Vector2
var velocity_end

var game_over = "no"
var cont_flash := 0
var clear_array := []

func set_game_over(txt):
	game_over = txt
	if game_over == "pausado":
		eliminar_instancias()
		
func transform_node(pos):
	position_start=pos
	position=pos
	
	start()	

func start():
	scale = Vector2(1,1)
	$AnimatedSprite.play("ride")
	
func ending(end_pos : Vector2):
	position_end = end_pos
	velocity_end =position_end-position

func eliminar_instancias():
	for node in clear_array:
		if is_instance_valid(node):
			if node.has_method("clear_node"):
				node.clear_node()
	clear_array.clear()

func _physics_process(delta):
	var velocity := Vector2()
	## ATENCION valores absolutos por  movimiento 
	## camara de -1,0,1, valores porporcionales como Joystick Analogico
	if game_over == "no":
		#Move the biker
		velocity.x = Remote.get_x_axis(player1,false)
		
		#Throwing Paper left o right
		if Remote.get_x_axis(player2,true) == -1 and !throwing:
			throwPaper("left")
			$AnimatedSprite.play("throw_left")
		elif Remote.get_x_axis(player2,true) == 1 and !throwing:
			throwPaper("right")
			$AnimatedSprite.play("throw_right")
		
		var m_axis : float
		
		if Remote.get_x_axis_joy(player1) != 0.0:
			m_axis = Remote.get_x_axis_joy(player1)
			print("Axis " + str(m_axis))
			position += Vector2.RIGHT * (speed*m_axis) * delta
		##########################################
		# Si QUEREMOS POSICION RELATIVA AL MANDO #
		##########################################
			#position.x = position_start.x + (position_start.x + (position_limit_right - position_limit_left/2.0)) * m_axis
		#else:
			#position.x = position_start.x
			
		
			
				
		if !$AnimatedSprite.animation.begins_with("pb_throw") and $AnimatedSprite.frame == 3:
				$AnimatedSprite.play("ride")
				
		if velocity.length()>0:
			position += velocity.normalized() * speed * delta
						
		position.x = clamp(position.x,position_limit_left,position_limit_right)
			
	elif game_over == "good":
		position += velocity_end.normalized() * speed * delta
		if (position_end - position).length() <= 1.0:
			velocity_end = Vector2()
			position = position_end
			if scale.x >= 0.1 :
				scale.x -= 0.5 * delta
				scale.y -= 0.5 * delta
			else:
				emit_signal("biker_end",game_over)
	elif game_over == "bad":
		if scale.x >= 0.1 :
			scale.x -= 0.5 * delta
			scale.y -= 0.5 * delta
		else:
			emit_signal("biker_end",game_over)
			

func throwPaper(dir):
	$AudioThrowPaper.play()
	var paper_destination := Vector2()
	throwing = true	
	yield(get_tree().create_timer(0.25), "timeout")
	
	var arm_position
	if dir == "left":
		paper_destination =Vector2(-3,-1)
		arm_position = $AnimatedSprite/PaperPositionLeft.global_position
	elif dir == "right":
		paper_destination =Vector2(3,-1)
		arm_position = $AnimatedSprite/PaperPositionRight.global_position
	
	
	var new_paper = Paper.instance() 
	clear_array.append(new_paper)
	new_paper.transform_node(paper_destination.normalized(),arm_position,dir)
	get_parent().add_child(new_paper)
	throwing = false	
	
func dead():
	if cont_flash == 0 and game_over == "no" :
		$TimerImpacto.start()
		emit_signal("hit")
		cont_flash = 11
		
func _on_TimerImpacto_timeout():
	visible = visible == false
	cont_flash -= 1
	if cont_flash == 0:
		$TimerImpacto.stop()
		visible = true
