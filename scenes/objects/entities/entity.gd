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
var action_display : IntentIndicator 

@export 
var stats : EntityStats 

#adjectives for randomly describing our actions
@export
var adjectives : Array[String] = ["angrily","visciously","excitedly","slowly","sadly","agressivly"]

#represents the roll that will be used in the next
#step of the game
var next_roll : int :
	set(val):
		next_roll = val 
	get:
		return next_roll

var next_target = null 

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
func on_intent_set(given_intent):
	if given_intent == Intent.ATTACK or given_intent == Intent.SEDUCE:
		next_target = get_target()
	else:
		next_target = null

#returns an entity from our container that is not us
#defaults to purly random, this could be overiden for more
#interesting behavior in the future
func get_target():
	var family = get_parent().get_children()
	var sibling = family[randi() % len(family)]
	
	while sibling == self:
		sibling = family[randi() % len(family)]
	
	return sibling

func on_focus_enter()->void:
	modulate = Color(0,0,0)
func on_focus_exit()->void:
	self.modulate = Color(1,1,1)
func on_mouse_entered():
	var p = get_parent()
	if p.has_method("set_focused_entity"):
		p.set_focused_entity(self)
func intent2str(given_intent : int)->String:
	match given_intent:
		Intent.ATTACK:
			return "attack"
		Intent.DEFEND:
			return "defend"
		Intent.INTERACT:
			return "interact"
		Intent.SEDUCE:
			return "seduce" 
		_:
			return "~.~"
func describe_intent()->String:
	var ret_val =  name + " plans to " + adjectives[randi()%len(adjectives)] + " " + intent2str(self.intent) +" "
	if next_target != null:
		ret_val += next_target.name 
	ret_val += " with a roll of %s"
	return ret_val
# Called when the node enters the scene tree for the first time.
func _ready():
	intent_set.connect(on_intent_set)
	self.mouse_entered.connect(on_mouse_entered)
