extends RigidBody3D

@export var speed: float = 500.0
@export var lifetime: float = 5.0

func _ready():
	# Poista projektiili tietyn ajan kuluttua
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(_delta):
	# Liikuta projektiilia eteenpäin
	linear_velocity = transform.basis.z * -speed
