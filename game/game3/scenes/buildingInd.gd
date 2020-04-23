extends Sprite


export var move_speed = 15
var velocity = Vector2()

onready var free_node := false

func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta

func transform_node(vel,pos,side):
	position=pos
	velocity=vel
	randomize()
	frame = randi() % 7
	if side =="Right":
		flip_h = true
	elif side =="Left":
		flip_h = false

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
