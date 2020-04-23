extends Area2D


export var move_speed = 15
var velocity = Vector2()
var hit := true setget ,get_hit
var destination : Vector2

var razon : float
var distance : float
var my_scale : Vector2
var scale_min := 0.35
var scale_max := 1.0

onready var free_node := false

func get_hit():
	return hit

func _ready():
	pass

func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta
		
		# Vamos obteniendo la razon entre la distancia que vamos recorriendo
		# y la distancia total de lo que tenemos que recoger
		razon = (position.y-distance)/distance
		scale.y = clamp(my_scale.y * razon,scale_min,scale_max)
		scale.x = clamp(my_scale.x * razon,scale_min,scale_max)

func transform_node(vel,pos,des):
	position=pos
	velocity=vel
	destination=des
	# Obtenemos la distancia total ha recorrer
	distance = destination.y - position.y
	my_scale = scale
	scale *= scale_min

func _on_Stone_area_entered(area):
	if area.has_method("dead"):
	#if !area.get_hit():
		$AudioStoneCollision.play()
		area.dead()

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
