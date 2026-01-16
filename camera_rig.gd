extends Node3D

@export var active_boat : Node3D = null
@export var offset := Vector3(0, 5, -10)  # oletus-offset veneestä
@export var rotate_speed := 0.06           # hiiren nopeus
@export var zoom_speed := 2.0             # rullan nopeus
@export var min_distance := 3.0           # lähin zoom
@export var max_distance := 20.0          # kauin zoom

var rotation_x := 0.0
var rotation_y := 0.0
var distance := 10.0  # etäisyys veneestä

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	distance = -offset.z

func _unhandled_input(event):
	# Hiiren liike pyöritystä varten
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * rotate_speed
		rotation_x -= event.relative.y * rotate_speed
		rotation_x = clamp(rotation_x, -30, 60)

	# Hiiren rullaus zoomaukseen
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 4:  # rulla ylös
			distance -= zoom_speed
		elif event.button_index == 5:  # rulla alas
			distance += zoom_speed
		distance = clamp(distance, min_distance, max_distance)

func _process(_delta):
	if not active_boat:
		print("active_boat ei ole asetettu!")
		return

	# Haetaan veneen camera_offset jos se on määritelty
	var boat_offset = Vector3(0, 5, -10)
	if "camera_offset" in active_boat:
		boat_offset = active_boat.camera_offset

	# Lasketaan offset
	var current_offset = Vector3(offset.x, offset.y, -distance)

	# Horisontaalinen kierto veneen Y-akselin ympäri
	var rotated_offset = current_offset.rotated(Vector3.UP, deg_to_rad(rotation_y))

	# Pystysuora kierto kameran paikallisen oikean akselin ympäri
	var right_axis = rotated_offset.cross(Vector3.UP).normalized()
	rotated_offset = rotated_offset.rotated(right_axis, deg_to_rad(rotation_x))

	# Asetetaan kamera paikalleen
	global_position = active_boat.global_position + rotated_offset

	# Kamera katsoo veneen yläpuolelle
	var focus_point = active_boat.global_position + Vector3(0, boat_offset.y, 0)
	look_at(focus_point, Vector3.UP)
