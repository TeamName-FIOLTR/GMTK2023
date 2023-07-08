extends Node2D
class_name Card

var card_box #reference to our parent container, whatever it may be

@export var number_display : Label

@export var number : int = 10 :
	set (val):
		number = val 
		if number_display:
			number_display.text = str(number)
	get:
		return number

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
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		card_box.selected_card = self
#		print("/")
#		if abs(event.relative.x)<abs(event.relative.y):
#			if pos_tween:
#				pos_tween.kill()
#			$Sprite2D.global_position = get_global_mouse_position()
#	elif event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
#			reset_position()
	pass # Replace with function body.

func reset_position():
	tween_to(Vector2(0,0))
func tween_to(target : Vector2,speed : float = 6/60.0,property="position"):
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
	pos_tween.tween_property(self, property, target, speed)


#func _on_input_area_mouse_exited():
#	reset_position()
#	pass # Replace with function body.
