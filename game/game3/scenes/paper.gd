extends Area2D

export var fire_speed = 50  # Maximum speed range.
var velocity := Vector2()

onready var free_node := false

func _ready():
	$AnimatedSprite.play("fly")

func _physics_process(delta):
	position += velocity * fire_speed * delta
	
func transform_node(vel,pos,dir):
	position=pos
	velocity=vel
	$AnimatedSprite.flip_h = dir == "right"

func _on_Paper_area_entered(area):
	if area.has_method("read_paper"):
		if !area.get_hit():
			area.read_paper()
			clear_node()

func _on_VisibilityNotifier2D_screen_exited():
		clear_node()
		
func clear_node():
	if !free_node:
		free_node = true 
		queue_free()
