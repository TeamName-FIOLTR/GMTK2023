extends Node2D
class_name Card

@export var number : int = 10

var pos_tween : Tween

func _init(card_number = 100):
	number=card_number


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_area_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		print("/")
		if abs(event.relative.x)<abs(event.relative.y):
			if pos_tween:
				pos_tween.kill()
			$Sprite2D.global_position = get_global_mouse_position()
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			reset_position()
	pass # Replace with function body.

func reset_position():
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
	pos_tween.tween_property($Sprite2D, "position", Vector2(0, 0), 6/60.0)


func _on_input_area_mouse_exited():
	reset_position()
	pass # Replace with function body.
