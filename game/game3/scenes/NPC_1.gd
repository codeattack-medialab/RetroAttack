extends KinematicBody2D


export var move_speed = 50
var velocity = Vector2()
var first_vector = Vector2()
var move = "stop"
var last_move
var first_move
var pausa = false

func _ready():
	position = Vector2(67,97)
	pass


func _physics_process(delta):
	velocity = Vector2()
	match move:
			"Right":
				last_move = animando(move)
				velocity.x += 1
			"Left":
				last_move = animando(move)
				velocity.x += -1
			"Up":
				last_move = animando(move)
				velocity.y += -1
			"Down":
				last_move = animando(move)
				velocity.y += 1
			"Stop":
				last_move = animando(move)
			"Paperboy":
					velocity = Vector2(-79,50)
					last_move = animando("Down")
				
#	if velocity.length() == 0 :
#		$Sprite/AnimationPlayer.stop(false) # Con stop(false) se pausa la animacion

	move_and_slide(velocity.normalized() * move_speed)


func animando(anim):
	$Sprite/AnimationPlayer.play(anim)
	return anim

func _on_Timer_timeout():
	
	if !pausa:
		match 5: #randi() % 5:     # returns random integer between 0 and 4:
			0:
				move = "Right"
			1:
				move = "Left"
			2:
				move = "Up"
			3:
				move = "Down"
			4:
				move = "Stop"
			5: 
				move ="Paperboy"
	else:
		move = "Stop"
	velocity
	
	
func set_pausa(new_value):
	pausa = new_value
	if pausa:
		$Sprite/AnimationPlayer.stop(false)
		move = "Stop"
	else:
		_on_Timer_timeout()

func get_pausa():
	return pausa

