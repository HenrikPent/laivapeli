extends CanvasLayer

@onready var pause_menu = $PauseMenu

func _ready():
	pause_menu.visible = false

func _input(event):
	if event.is_action_pressed("key_escape"):
		# toggle pause / näytä valikko
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	get_tree().paused = true
	pause_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Button signalit
func _on_Resume_pressed():
	resume_game()

func _on_Quit_pressed():
	get_tree().quit()


func _on_resume_pressed() -> void:
	pass # Replace with function body.
