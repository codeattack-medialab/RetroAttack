extends Area2D


export var move_speed = 10
var velocity = Vector2()
var hit := true setget ,get_hit
var y_temp := 0
var razon : float

func get_hit():
	return hit

func _ready():
	$Sprite/AnimationPlayer.play("Stop")

func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta
		if y_temp != int(position.y)-75:
			
			y_temp = int(position.y)-75
			razon = float(y_temp)/float(75)
			scale.y = clamp(1.0 * razon,0.25,1)
			scale.x = clamp(1.0 * razon,0.25,1)
			
			print(razon)
			print (scale)

func transform_node(vel,pos):
	position=pos
	velocity=vel
	y_temp = int(position.y) -75
	print(y_temp)
	scale *= 0.25

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#func read_paper():
#	hit = true
#	$CollisionShape2D.set_deferred("disabled", true) 
#	$Sprite/AnimationPlayer.play("Hit")
#	yield(get_tree().create_timer(1.0), "timeout")
#	queue_free()


func _on_Stone_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.has_method("hit_stone"):
		#if !area.get_hit():
		area.hit_stone()
		#	queue_free()
