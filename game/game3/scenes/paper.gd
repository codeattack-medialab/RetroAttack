extends Area2D


var display := Vector2()

export var fire_speed = 50  # Maximum speed range.

var velocity := Vector2()
var ready = false


func _ready():
	hide()
	if !$TimerDelay.autostart:
		_on_TimerDelay_timeout()

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

func _on_Paper_area_entered(area):
	if area.has_method("read_paper"):
		area.read_paper()

