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
		if draw_indicator:
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
		if rules_text:
			rules_text.text = val 
		rules_str = val 
	get:
		return rules_str 

@export var intent_target : Entity.Intent = Entity.Intent.EMPTY

@onready var number_display : Label = $"Sprite2D/text/numberDisplay"
@onready var rules_text : Label = $"Sprite2D/Rules Text/Label"
@onready var draw_indicator : Label = $"Sprite2D/Rules Text/Draw Amount"
@onready var intent_limit_text : Label = $"Sprite2D/Rules Text/Intent Limit"


var pos_tween : Tween

func _init(card_number = 100):
	number=card_number


func update_display()->void:
	self.number = number #call the setter getter to ensure that we are synced
	self.draw_amount = draw_amount 
	if rules_str != "":
		self.rules_str = rules_str
	if self.intent_target != Entity.Intent.EMPTY:
		intent_limit_text.text = "on %s" % Entity.intent2str(self.intent_target)
		intent_limit_text.visible = true 
	else:
		intent_limit_text.visible = false 
	intent_limit_text.visible = true

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
		if card_box:
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

#called only if we match intents
func play_effect(_decks : RotaryDeck,_entity : Entity)->void:
	if draw_amount > 0:
		print("drawing card! " +str(number) )
		_decks.draw_card(draw_amount)
	elif draw_amount < 0:
		print("discarding card!"+ str(number))
		_decks.discard_random(abs(draw_amount))
	pass

#called everytime we play a card
func on_play(_decks : RotaryDeck,_entity : Entity)->void:
	if _entity.intent == self.intent_target or self.intent_target == Entity.Intent.EMPTY:
		play_effect(_decks,_entity)
