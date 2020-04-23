extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.rotated(PI/4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
				
		
		$Tween.interpolate_property(self,"position",position,mouse_pos,1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
#		$Tween.interpolate_property(self,"position:x",position.x,position.x +100,2,Tween.TRANS_LINEAR,Tween.EASE_IN)
#		$Tween.interpolate_property(self,"position:y",position.y,position.y -100,2,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
		$Tween.start()
		self.position += velocity
	if Input.is_action_just_pressed("mlp_p1_left"):
		#$Tween.interpolate_property(self,"position",position,position+Vector2(-100,50),2,Tween.TRANS_BOUNCE,Tween.EASE_IN)
		$Tween.interpolate_property(self,"position",position,position-Vector2(0,50),0.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
		$Tween.start()
	pass  
