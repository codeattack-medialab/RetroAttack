extends Area2D

export (PackedScene) var Mov_evil


export var move_speed = 25
var velocity = Vector2()
var animations = ["Left","Up","Right","Down"]
var hit := false setget ,get_hit

func get_hit():
	return hit

func _ready():
	$Sprite/AnimationPlayer.play("Down")
	
func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta

func transform_node(vel,pos):
	#position=pos
	global_position=pos
	velocity=vel

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func read_paper():
	hit = true
	if !get_parent().get_node("Game3").get_mov_array_full():
		get_parent().get_node("Game3").build_mov_collage(global_position)
	$CollisionShape2D.set_deferred("disabled", true) 
	
	for i in range(4):
		$Sprite/AnimationPlayer.play(animations[i])
		yield(get_tree().create_timer(0.2), "timeout")	
	queue_free()
	
	
	
	
