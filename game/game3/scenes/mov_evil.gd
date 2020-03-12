extends Area2D


export var move_speed = 10
var velocity = Vector2()
var animations = ["Left","Up","Right","Down"]
var hit := false setget set_hit,get_hit
var destination : Vector2

func get_hit():
	return hit
	
func set_hit(state):
	hit = state
func _ready():
	$Sprite/AnimationPlayer.play("Down")

func _physics_process(delta):
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta
		if (destination - position).length() <= 1:
			velocity = Vector2()

func transform_node(vel,pos,des):
	position=pos
	velocity=vel
	destination = des



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func read_paper():
	hit = true
	$CollisionShape2D.set_deferred("disabled", true) 
	$Sprite/AnimationPlayer.play("Hit")
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
