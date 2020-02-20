extends Area2D


export var move_speed = 50
var velocity = Vector2()
var animations = ["Left","Up","Right","Down"]

func _ready():
	pass

func _physics_process(delta):
						
	if velocity.length() != 0 :
		position += velocity.normalized() * move_speed * delta

func launch_passerby(left: bool):
	if left: # left
		position = Vector2(67,97)
		velocity = Vector2(-79,50)
	else: #right
		position = Vector2(127,97)
		velocity = Vector2(80,50)
	$Sprite/AnimationPlayer.play("Down")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func read_paper():
	for i in range(4):
		$Sprite/AnimationPlayer.play(animations[i])
		#$Sprite.flip_v = $Sprite.flip_v == false
		yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
