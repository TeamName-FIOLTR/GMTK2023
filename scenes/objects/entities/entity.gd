extends Area2D

class_name Entity

signal intent_set

enum Intent {
	ATTACK,
	DEFEND,
	INTERACT,
	SEDUCE
}

@export 
var stats : EntityStats 
@export 
var action_display : IntentIndicator 


#represents the roll that will be used in the next
#step of the game
var next_roll : int :
	set(val):
		next_roll = val 
	get:
		return next_roll

var intent : int = 0 :
	set(val):
		intent = val 
		action_display.animate_set(intent)
	get:
		return intent

#tries to perform the given action and
#returns true if sucessful
func attempt()->bool:
	return self.next_roll >= get_difficulty()

#figure out later lol , hey thats our name!
func get_difficulty()->int:
	return 10
func make_intent()->void:
	self.intent = stats.get_action()
	intent_set.emit(self.intent)

#we can use this function to run extra code
#per each selected intent
func on_intent_set(intent):
	print(self.name + " set intent to " + str(self.intent))

func on_focus_enter()->void:
	print("focus enter " + self.name)
	modulate = Color(0,0,0)
func on_focus_exit()->void:
	print("focus exit " + self.name)
	self.modulate = Color(1,1,1)
func on_mouse_entered():
	var p = get_parent()
	if p.has_method("set_focused_entity"):
		p.set_focused_entity(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	intent_set.connect(on_intent_set)
	self.mouse_entered.connect(on_mouse_entered)
