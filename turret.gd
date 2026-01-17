extends Node3D

@export var barrel: Node3D
@export var yaw_speed := 60.0
@export var pitch_speed := 60.0
@export var down_max_pitch := -40.0  # alas (negatiivinen)
@export var up_max_pitch := 10.0     # ylös (positiivinen)
@export var max_aim_distance := 500.0

func _process(_delta):
	if not barrel:
		return

	var target_pos = CameraData.hit_position
	var barrel_global = barrel.global_transform.origin
	
	# Barrel ja target pos on jo määritelty aiemmin
	var dir = target_pos - barrel_global

	# 1️⃣ Suora pitch kohteen korkeuteen
	var horizontal_dist = sqrt(dir.x * dir.x + dir.z * dir.z)
	var base_pitch = atan2(dir.y, horizontal_dist)
	base_pitch = -base_pitch  # käännetään merkki Godotissa ylös/alas

	# 2️⃣ Lisäkulma etäisyyden mukaan
	var max_distance_for_pitch = 500.0      # kovakoodattu etäisyys maksimikulmalle
	var max_extra_pitch_deg = -40.0          # kuinka paljon ylimääräistä kulmaa lisätään
	var distance_to_target = barrel_global.distance_to(target_pos)
	
	# Lasketaan kerroin (0…1), ei mene yli 1
	var distance_factor = clamp(distance_to_target / max_distance_for_pitch, 0.0, 1.0)
	
	# Lisätään ylimääräinen kulma base_pitchiin
	var extra_pitch = deg_to_rad(max_extra_pitch_deg) * distance_factor
	var adjusted_pitch = base_pitch + extra_pitch
	
	# Smooth pitch ja clamp
	var pitch_diff = adjusted_pitch - barrel.rotation.x
	barrel.rotation.x += clamp(pitch_diff, -deg_to_rad(pitch_speed * _delta), deg_to_rad(pitch_speed * _delta))
	barrel.rotation.x = clamp(barrel.rotation.x, deg_to_rad(down_max_pitch), deg_to_rad(up_max_pitch))

	# Yaw lasketaan normaalisti
	var desired_yaw = atan2(-dir.x, -dir.z)
	var yaw_diff = wrapf(desired_yaw - global_rotation.y, -PI, PI)
	global_rotation.y += clamp(yaw_diff, -deg_to_rad(yaw_speed * _delta), deg_to_rad(yaw_speed * _delta))
