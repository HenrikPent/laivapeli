#Tää ohjaa kameraa ja kattoo samalla mihin pelaaja tähtää

extends Node3D

@export var active_boat : Node3D = null
@export var offset := Vector3(0, 5, -10)
@export var rotate_speed := 0.06
@export var zoom_speed := 2.0
@export var min_distance := 3.0
@export var max_distance := 20.0

var rotation_x := 0.0
var rotation_y := 0.0
var distance := 10.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	distance = -offset.z

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * rotate_speed
		rotation_x += event.relative.y * rotate_speed
		rotation_x = clamp(rotation_x, -30, 60)

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 4:
			distance -= zoom_speed
		elif event.button_index == 5:
			distance += zoom_speed
		distance = clamp(distance, min_distance, max_distance)

func _process(_delta):
	if not active_boat:
		return

	var boat_offset = Vector3(0, 5, -10)
	if "camera_offset" in active_boat:
		boat_offset = active_boat.camera_offset

	var current_offset = Vector3(offset.x, offset.y, -distance)
	var rotated_offset = current_offset.rotated(Vector3.UP, deg_to_rad(rotation_y))
	var right_axis = rotated_offset.cross(Vector3.UP).normalized()
	rotated_offset = rotated_offset.rotated(right_axis, deg_to_rad(rotation_x))

	global_position = active_boat.global_position + rotated_offset
	var focus_point = active_boat.global_position + Vector3(0, boat_offset.y, 0)
	look_at(focus_point, Vector3.UP)

	# --- Raycast joka frame ---
	var space_state = get_world_3d().direct_space_state
	var origin = global_position
	var direction = -global_transform.basis.z
	var end = origin + direction * 1000.0
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if result:
		CameraData.hit_position = result.position
