extends Area2D

export var fire_speed = 50  # Maximum speed range.
var velocity := Vector2()

func _ready():
	$AnimatedSprite.play("fly")

func _physics_process(delta):
	position += velocity * fire_speed * delta
	
func transform_node(vel,pos,dir):
	position=pos
	velocity=vel
	$AnimatedSprite.flip_h = dir == "right"

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Paper_area_entered(area):
	if area.has_method("read_paper"):
		if !area.get_hit():
			area.read_paper()
			queue_free()
