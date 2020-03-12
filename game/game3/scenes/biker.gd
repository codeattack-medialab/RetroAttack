extends Area2D

export (PackedScene) var Paper
export var speed = 50
var throwing := false
var player1 := 1
var player2 := 2

func _ready():
	start()

func start():
	$AnimatedSprite.play("ride")
	show()
	#$CollisionShape2D.disabled = false

func _physics_process(delta):
	var velocidad : Vector2
	## ATENCION valores absolutos por camara de -1,0,1
	#Move the biker
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

func transform_node(pos):
	position=pos

func throwPaper(dir):
	var paper_destination := Vector2()
	throwing = true	
	yield(get_tree().create_timer(0.25), "timeout")
	
	var arm_position
	if dir == "left":
		paper_destination =Vector2(-3,-1)
		arm_position = $AnimatedSprite/PaperPositionLeft.global_position
	elif dir == "right":
		paper_destination =Vector2(3,-1)
		arm_position = $AnimatedSprite/PaperPositionRight.global_position

	var new_paper = Paper.instance() 
	new_paper.transform_node(paper_destination.normalized(),arm_position,dir)
	get_parent().add_child(new_paper)
	throwing = false	
	
func hit_stone():
	hide()
	pass

func _on_Biker_area_shape_exited(area_id, area, area_shape, self_shape):
	show()
	pass # Replace with function body.
