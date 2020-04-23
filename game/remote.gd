extends Node


func get_x_axis(player: int, just_pressed: bool	):
	
	if just_pressed:
		if Input.is_action_just_pressed("mlp_p%d_left" % player) or get_remote_command() == "p%d_left" % player:
			return -1
		elif Input.is_action_just_pressed("mlp_p%d_right"  % player) or get_remote_command() == "p%d_right" % player:
			return 1
		else:
			return 0
	else:
		if Input.is_action_pressed("mlp_p%d_left" % player) or get_remote_command() == "p%d_left" % player:
			return -1
		elif Input.is_action_pressed("mlp_p%d_right"  % player) or get_remote_command() == "p%d_right" % player:
			return 1
		else:
			return 0
		
		
func get_y_axis(player: int, just_pressed: bool):
	
	if just_pressed:
		if Input.is_action_just_pressed("mlp_p%d_up" % player) or get_remote_command() == "p%d_up" % player:
			return -1
		elif Input.is_action_just_pressed("mlp_p%d_down" % player) or get_remote_command() == "p%d_down" % player:
			return 1
		else:
			return 0
	else:
		if Input.is_action_pressed("mlp_p%d_up" % player) or get_remote_command() == "p%d_up" % player:
			return -1
		elif Input.is_action_pressed("mlp_p%d_down" % player) or get_remote_command() == "p%d_down" % player:
			return 1
		else:
			return 0
		
func get_action(player: int, just_pressed: bool):
	if just_pressed:
		if Input.is_action_just_pressed("mlp_p%d_action" % player) or get_remote_command() == "p%d_action" % player:
			return 1
		else:
			return 0
	else:
		if Input.is_action_pressed("mlp_p%d_action" % player) or get_remote_command() == "p%d_action" % player:
			return 1
		else:
			return 0
		
func get_remote_command():
	return ""
	
func get_x_axis_joy(player: int):
	
	var axis
	#return Input.get_action_strength("mlp_p%d_stick_left"  % player)
	if Input.get_action_strength("mlp_p%d_stick_left" % player) >= 0.05:
		axis = Input.get_action_strength("mlp_p%d_stick_left" % player)
		#print("I " + str(m_axis))
		return (axis * -1)
	elif Input.get_action_strength("mlp_p%d_stick_right" % player) >= 0.05:
		axis = Input.get_action_strength("mlp_p%d_stick_right" % player)
		#print("D " + str(m_axis))
		return axis
	else:
		return 0.0
			
	
#func get_x_axis_joyD(player: int):
#
#
#	return Input.get_action_strength("mlp_p%d_stick_right"  % player)
		
