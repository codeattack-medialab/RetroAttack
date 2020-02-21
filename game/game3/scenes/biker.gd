extends Area2D

export (PackedScene) var paper
export var speed = 50
var screen_size : Vector2
var throwing := false
var player1 := 1
var player2 := 2


func _ready():
	start()

func start():
	screen_size = get_viewport_rect().size
	position.x =  screen_size.x / 2
	position.y = 140
	$AnimatedSprite.play("ride")
	show()
	#$CollisionShape2D.disabled = false

func _physics_process(delta):
	var velocidad : Vector2
	
	#Move de biker
	velocidad.x = Remote.get_x_axis(player1,false)
	
	#Throwing Paper left o right
	if Remote.get_x_axis(player2,true) == -1 and !throwing:
		throwPaper("left")
		$AnimatedSprite.play("throw_left")
	elif Remote.get_x_axis(player2,true) == 1 and !throwing:
		throwPaper("right")
		$AnimatedSprite.play("throw_right")
			
	
	if !$AnimatedSprite.animation.begins_with("pb_throw") and $AnimatedSprite.frame == 3:
			$AnimatedSprite.play("ride")
			
	if velocidad.length()>0:
		position += velocidad.normalized() * speed * delta
		position.x = clamp(position.x,40,170)
	

func throwPaper(dir):
	var destination := Vector2()
	
	var new_paper = paper.instance() 
	throwing = true	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var bike_position = position
	if dir == "left":
		destination =Vector2(-3,-1)
		bike_position.x -=8
	elif dir == "right":
		destination =Vector2(3,-1)
		bike_position.x +=8
		
	bike_position.y -=8
	new_paper.transformPaper(destination.normalized(),bike_position,dir)
	get_parent().add_child(new_paper)
	throwing = false	
	
