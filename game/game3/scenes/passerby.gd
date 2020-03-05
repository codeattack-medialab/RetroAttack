extends Area2D

export (PackedScene) var Obstacle


export var move_speed = 50
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
	position=pos
	velocity=vel

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func read_paper():
	hit = true
	$CollisionShape2D.set_deferred("disabled", true) 
	var position_from =  global_position
	var position_to =  get_tree().get_root().get_node("Game3").get_MovEvilAnimatedSprite_position()
	var new_obstacle = Obstacle.instance()
	new_obstacle.transform_node(position_to-position_from,position_from)
	get_parent().add_child(new_obstacle)
	for i in range(4):
		$Sprite/AnimationPlayer.play(animations[i])
		yield(get_tree().create_timer(0.2), "timeout")
	

	
	queue_free()
	
	
	
	
