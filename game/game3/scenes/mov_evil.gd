extends Area2D



export var move_speed = 25
var velocity := Vector2()
var velocity_shadow := Vector2()
var destination : Vector2
var position_shadow : Vector2
var destination_shadow : Vector2

var distance : float
var shadow_distance :float
var razon : float


var one_time := false #false
var jump_size := float(20.0)

var hit := false setget set_hit,get_hit
onready var free_node := false

var biker
signal end_street

func get_hit():
	return hit
	
func set_hit(state):
	hit = state
	
	
func _ready():
	$CollisionShape2D.set_deferred("disabled", true) 
	$Sprite/AnimationPlayer.play("Fly")
	$Tween.interpolate_property(self,"position",position,position-Vector2(0,jump_size),0.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$Tween.start()
	

func _physics_process(delta):
	if $Tween.is_active() and one_time == false:
		$Sombra.global_position = position_shadow
		
	
	if !$Tween.is_active() and one_time == false:
		one_time = true
		trayectory()
		$AudioMovEvilEscape.play()
		$Tween.interpolate_property(self,"position",position,destination,1,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.interpolate_property($Sombra,"global_position",position_shadow,destination_shadow,1,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		$Tween.start()
		velocity = Vector2()
		velocity_shadow = Vector2()
		$CollisionShape2D.set_deferred("disabled", false) 
	
	
	if velocity.length() != 0 and  $Tween.is_active() == false :
		# suaveizar movimiento en la llegada
		
		position += velocity.normalized() * move_speed * delta
		
		
		if $Sombra.visible: # Si hay sombra calculamos si posicion
			
			### No lo usamos con los Tweens ###
			
#			# Restamos a sombra el movimiento del personaje 
#			$Sombra.global_position -= velocity.normalized() * move_speed * delta
#			# Movimiento de la sombra corrigiendo la velocidad con la razon de las distancias
#			$Sombra.global_position += velocity_shadow.normalized() * (move_speed * razon) * delta
			pass
		else:
			if !$AudioJump.playing and hit == false:
				$AudioJump.play()
	
		if (destination - position).length() <= 1.0:
			velocity = Vector2()
			velocity_shadow = Vector2()
			position = destination
			emit_signal("end_street",self)
			


func transform_node(pos,des,des_sha):
	position = pos # Posicion Origen MovEvil
	position_shadow = pos # Posicion Origen Sombra
	destination = des # Posicion Destino MovEvil
	if des_sha.length() == 0:
		$Sprite/AnimationPlayer.play("Jump")
		$Sombra.hide()
	
	destination_shadow = Vector2(des_sha.x,des_sha.y-10) # Posicion Destino Sombra corregida
	
	if one_time:
		trayectory()
	
	
func trayectory():
	velocity = destination-position # Vector Movimiento Movil	
	distance = (destination - position).length() # Distancia Recorre MovEvil
	velocity_shadow = destination_shadow - position_shadow # Vector Movimiento Sombra
	
	if !hit:
		move_speed = 25
	
	### No lo usamos con los Tweens
	
#	shadow_distance =(destination_shadow - position_shadow).length() # Distancia Recorre Sombra
##	# Razon:  La distancia recorrida por la sombra entre la distancia recorrida
#	# por el MovEvil, con esa proporcion ajustaremos la velocidad de ambos desplazamientos
#	razon = shadow_distance/distance 
	
	
func read_paper(): # Si recibe un impacto del periodico
	#hit = true
	$AudioDeadForPaper.play()
	die()

func _on_MovEvil_area_entered(area): # Si colisiona con el Biker
	if area.has_method("dead"):
	#if !area.get_hit():
		area.dead()
		$AudioDeadForBike.play()
		die()
		
func die():
	hit = true
	$CollisionShape2D.set_deferred("disabled", true) 
	$Sprite/AnimationPlayer.play("Hit")
	make_solid_to_transparent(1)
	$TimerClearNode.start()
	#queue_free()

func _on_TimerClearNode_timeout():
	clear_node()

func _on_VisibilityNotifier2D_screen_exited():
	clear_node()

func clear_node():
	if !free_node:
		free_node = true 
		queue_free()

func make_transparent_to_solid(time : float):
	var color_transparent:= Color(1,1,1,0) # Blanco con transparencia
	var pasos = 0.1 # pasadas totales para el efecto
	var retardo = time * pasos
	while self.modulate.a <= 1:
		# la propiedadad Color.a es el canal alpha, con rango 0-1
		# Vamos aumentando su valor para quitar la trasnparencia
		# Y se lo pasamos a modulate del nodo
		color_transparent.a += pasos
		self.modulate = color_transparent
		yield(get_tree().create_timer(retardo), "timeout")

	self.modulate = Color(1,1,1,1) # Quitamos la transparencia

func make_solid_to_transparent(time : float):
	var color_transparent:= Color(1,1,1,1) # Blanco sin transparencia
	var pasos = 0.1 # pasadas totales para el efecto
	var retardo = time * pasos
	while self.modulate.a >= 0:
		# la propiedadad Color.a es el canal alpha, con rango 0-1
		# Vamos disminuyendo su valor para hacer la trasnparencia
		# Y se lo pasamos a modulate del nodo
		color_transparent.a -= pasos
		self.modulate = color_transparent
		yield(get_tree().create_timer(retardo), "timeout")

	self.modulate = Color(1,1,1,0) # Ponemos la transparencia
	


