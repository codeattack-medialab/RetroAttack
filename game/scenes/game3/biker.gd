extends Area2D


export var speed = 200
export (PackedScene) var paper
var screen_size : Vector2
var last_paper


#signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Viewport Resolution is: ", get_viewport_rect().size)
	$AnimatedSprite.play("ride")
	start()
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocidad : Vector2
	
	#if Remote.get_remote_x_axis(1) == 1:
	var player1 := 1
	var player2 := 2
	velocidad.x = Remote.get_x_axis(player1,false)
	if Remote.get_x_axis(player2,true) == -1:
		throwPaper("left")
		$AnimatedSprite.play("throw_left")
	elif Remote.get_x_axis(player2,true) == 1:
		throwPaper("right")
		$AnimatedSprite.play("throw_right")
	
#	if Input.is_action_pressed("mlp_p1_left"):
##		$AnimatedSprite.play("ride")
#		velocidad.x -=1
#
#	if Input.is_action_pressed("mlp_p1_right"):
##		$AnimatedSprite.play("ride")
#		velocidad.x +=1	

#	if Input.is_action_just_pressed("mlp_p2_left"):
#		throwPaper("left")
#		$AnimatedSprite.play("throw_left")
#		#$AnimatedSprite.flip_v=true
#
#
#	if Input.is_action_just_pressed("mlp_p2_right"):
#		throwPaper("right")
#		$AnimatedSprite.play("throw_right")
#		#$AnimatedSprite.flip_v=true			
		
	
	if !$AnimatedSprite.animation.begins_with("pb_throw") and $AnimatedSprite.frame == 3:
			$AnimatedSprite.play("ride")
			
	if velocidad.length()>0:
		position += velocidad.normalized() * speed * delta
		position.x = clamp(position.x,50,150)
	

func start():
	screen_size = get_viewport_rect().size
	position.x =  screen_size.x / 2
	position.y = 130
	show()
	$CollisionShape2D.disabled = false


#func _on_Player_body_entered(body):
#	#hide()
#	print(body.name)
#	if body.name !="Fire":
#		emit_signal("hit")
#		$CollisionShape2D.set_deferred("disabled", true) 
		
	#$CollisionShape2D.disabled=true #es lo mismo que arriba
#	Desactivar la forma de colisión del nodo Area puede causar un error 
#	si ocurre en medio del procesado de colisiones del motor. 
#	El uso de set_deferred() nos permite hacer que Godot espere 
#	para desactivar la forma hasta que sea seguro hacerlo.
	

func throwPaper(dir):
	var destination := Vector2()
	var bike_position = position
	var new_paper = paper.instance() # si haces un preload, se carga al instanciar
	if dir == "left":
		destination =Vector2(0,100)
		bike_position.x -=8
	elif dir == "right":
		destination =Vector2(190,100)
		bike_position.x +=8
		
	bike_position.y -=8
	destination = destination - bike_position
	new_paper.transformPaper(destination,bike_position,dir)
	last_paper = get_parent().add_child(new_paper)
	
