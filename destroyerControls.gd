extends Node3D

@export var speed := 15.0
@export var turn_speed := 60.0  # degrees per second
@export var water_level := 0.0  # veneen Y-asema veden pinnassa
@export var camera_offset := Vector3(0, 5, -10)  # oletusoffset

func _process(delta):
	# Eteen/taakse -1..1
	var forward_input = Input.get_action_strength("w") - Input.get_action_strength("s")
	
	# Liikutetaan vene Node3D:n oman eteen-suuntaisen vektorin mukaan
	if forward_input != 0:
		translate(Vector3.FORWARD * forward_input * speed * delta)
	
	# Käännös vasen/oikea
	var turn_input = Input.get_action_strength("d") - Input.get_action_strength("a")
	if turn_input != 0 and forward_input != 0:
		# sign(forward_input) kääntää ohjausta oikein peruuttaessa
		rotate_y(deg_to_rad(-turn_input * turn_speed * delta * sign(forward_input)))
	
	# Lukitaan veneen Y-koordinaatti
	var pos = global_position
	pos.y = water_level
	global_position = pos
