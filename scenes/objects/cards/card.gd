extends Node2D
class_name Card

var card_box #reference to our parent container, whatever it may be
func flip_up()->void:
	$AnimationPlayer.play("flip")
func flip_down()->void:
	$AnimationPlayer.play("flip",1.0,true)


@export var number : int = -10 :
	set (val):
		number = val 
		if number_display:
			number_display.text = str(number)
	get:
		return number

@export var draw_amount : int = 100:
	set(val):
		draw_amount = val 
		if val > 0:
			draw_indicator.visible = true
			draw_indicator.text = "draw %s"%draw_amount 
			draw_indicator.modulate = Color.DARK_GREEN
		elif val < 0:
			draw_indicator.visible = true
			draw_indicator.text = "discard %s"% abs(draw_amount)
			draw_indicator.modulate = Color.DARK_RED
		else:
			draw_indicator.text = "" 
			draw_indicator.visible = false
			
	get:
		return draw_amount 
@export var rules_str : String = "Click To \nPlay :D" :
	set(val):
		rules_text.text = val 
		rules_str = val 
	get:
		return rules_str 

@export var number_display : Label
@export var rules_text : Label
@export var draw_indicator : Label



var pos_tween : Tween

func _init(card_number = 100):
	number=card_number


func update_display()->void:
	self.number = number #call the setter getter to ensure that we are synced
	self.draw_amount = draw_amount 
	self.rules_str = rules_str
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.animation_finished.connect(on_anim_finished)
	$AnimationPlayer.play("flip_state")
	update_display()

func on_anim_finished(anim):
	pass 

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

func display_dice():
	$AnimationPlayer.play("Disapear")

func on_play(_decks : RotaryDeck,_entity : Entity)->void:
	if draw_amount > 0:
		_decks.draw_card(draw_amount)
	else:
		_decks.discard_random(abs(draw_amount))
