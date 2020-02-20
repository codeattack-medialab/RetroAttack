extends Area2D


var display := Vector2()

export var fire_speed = 1  # Maximum speed range.

var velocity := Vector2()
var ready = false


func _ready():
	hide()

func _physics_process(delta):
	if ready:
		position += velocity * fire_speed * delta
	
func transformPaper(vel,pos,dir):
	position=pos
	velocity=vel
	if dir == "left":
		$AnimatedSprite.flip_h=false
	elif dir =="right":
		$AnimatedSprite.flip_h=true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_TimerDelay_timeout():
	ready = true
	$AnimatedSprite.play("fly")
	show()

