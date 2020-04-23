extends Area2D

export (PackedScene) var Mov_evil

signal throw_MovEvil

export var move_speed =  20 #25
var velocity = Vector2()
# var animations = ["Left","Up","Right","Down"]
var hit := false setget ,get_hit

onready var free_node := false

func get_hit():
	return hit

func _ready():
	$Sprite/AnimationPlayer.play("WalkMovEvil")
	
func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta

func transform_node(vel,pos,side):
	#position=pos
	global_position=pos
	velocity=vel
	if side =="Right":
		$Sprite.flip_h = true	

func read_paper():
	$AudioReadPaper.play()
	hit = true
	$CollisionShape2D.set_deferred("disabled", true) 
	emit_signal("throw_MovEvil",global_position,self)
	$Sprite/AnimationPlayer.play("Surprise")
#	for i in range(4):
#		$Sprite/AnimationPlayer.play(animations[i])
#		yield(get_tree().create_timer(0.2), "timeout")	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Surprise":
		$Sprite/AnimationPlayer.play("OpenPaper")
	if anim_name == "OpenPaper":
		$Sprite/AnimationPlayer.play("ReadPaper")
	#if anim_name == "ReadPaper":
		#clear_node()

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
