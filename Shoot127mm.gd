extends Node3D

@export var projectile_scene: PackedScene
@export var fire_rate: float = 1.0
@export var muzzle: Node3D
@export var muzzle_flash: GPUParticles3D   # 🔥 tämä lisättiin

var can_fire = true

func fire():
	if not can_fire or projectile_scene == null:
		return

	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)

	# projektiili piipun päästä
	projectile.global_transform = muzzle.global_transform

	# 🔥 muzzle flash
	if muzzle_flash:
		muzzle_flash.restart()
		muzzle_flash.emitting = true

	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		fire()
