extends Area2D

class_name Entity

signal intent_set
signal die 
signal seduce

enum Intent {
	ATTACK,
	DEFEND,
	INTERACT,
	SEDUCE,
	EMPTY
}

func hide_dc()->void:
	$AnimationPlayer.play_backwards("dc")


@export var requires_input : bool = true
@export 
var difficultyTextDisplay : Label

@export var health_display : HeartDisplay

@export 
var action_display : IntentIndicator 

@export 
var stats : EntityStats 

#adjectives for randomly describing our actions
@export
var adjectives : Array[String] = ["angrily","visciously","excitedly","slowly","sadly","agressivly","indubitably","unorthadoxidly","swiftly","all cool-like","kinda"]

@export var sprite : Node2D

var has_focus : bool = false
@export var highlight : bool = false:
	set(n_highlight):
		highlight = n_highlight
		print(self)
		print(sprite)
		print(highlight)
		if sprite:
			sprite.material.set_shader_parameter("highlight", highlight)
#represents the roll that will be used in the next
#step of the game
var next_roll : int = -1:
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

var total_damage : int = 0
var total_defence : int = 0

func damage(amount : int)->void:
	total_damage += amount 

func defend(amount : int)->void:
	total_defence += amount 

func compute_damage_taken()->int:
	var ret_val : int = total_damage - total_defence 
	if ret_val < 0:
		return 0
	return ret_val 
#called to get a roll for AI,
#can be overidden
func generate_roll()->int:
	return randi()%20 +1

func ensure_roll()->void:
	if self.next_roll == -1:
		self.next_roll = generate_roll()

#actually applys the damage to the character, 
#inteanded for use in the damage step
func apply_damage()->void:
	stats.hp -= compute_damage_taken()
	if stats.hp <= 0:
		die.emit(self)	#tell whoever is interested in that we died
	health_display.current_health = stats.hp
	health_display.update_heart_values()
	
func handle_success()->void:
	match self.intent:
		Intent.ATTACK:
			next_target.damage(stats.attack)
		Intent.DEFEND:
			defend(stats.defence) 
		Intent.SEDUCE:
			seduce.emit(self,next_target)


#tries to perform the given action and
#returns true if sucessful
func attempt()->bool:
	var diff = get_difficulty()
	display_difficulty(diff)
	var ret_val = self.next_roll >= diff 
	
	if ret_val:
		handle_success()
	
	return ret_val


@export var check_pass_color : Color = Color.SEA_GREEN
@export var check_fail_color : Color = Color.INDIAN_RED
@export var difficulty_str : String = "v.s. %s"

@export var roll_display : DiceDisplay 

func display_difficulty(diff : int)->void:
	difficultyTextDisplay.text = difficulty_str % str(diff)
	roll_display.visible = true
	roll_display.target_value = self.next_roll
	if self.next_roll >= diff:
		$Difficulty.modulate = check_pass_color 
	else:
		$Difficulty.modulate = check_fail_color 
	
	$AnimationPlayer.play("dc")

#figure out later lol , hey thats our name!
func get_difficulty()->int:
	match self.intent:
		Intent.ATTACK:
			return next_target.stats.ac
		Intent.SEDUCE:
			return 20
		_:
			return randi()%20 + 1

#remove any lingering damage from the previous round
func clear_residuals()->void:
	total_damage = 0
	total_defence = 0

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
	modulate = Color(1,1,1)
	has_focus = true
func on_focus_exit()->void:
	self.modulate = Color(1,1,1)
	has_focus = false  
var mouse_in : bool = false
func on_mouse_entered():
	mouse_in = true
	var p = get_parent()
	if p.has_method("set_focused_entity"):
		p.set_focused_entity(self)
static func intent2str(given_intent : int)->String:
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
	var ret_val =  name + " plans to " + adjectives[randi()%len(adjectives)] + " " + Entity.intent2str(self.intent) +" "
	if next_target != null:
		ret_val += next_target.name 
	ret_val += " with a roll of %s"
	return ret_val 
func on_mouse_exited():
	mouse_in = false
func _input(event):
	if requires_input and mouse_in and has_focus and event is InputEventMouseButton and event.is_pressed():
		get_parent().entity_selected.emit(self)
# Called when the node enters the scene tree for the first time.
func _ready():
	if $art/Icon is AnimatedSprite2D:
		$art/Icon.play("default")
	health_display.max_health = stats.hp 
	health_display.current_health = stats.hp 

	health_display.init_hearts()
	health_display.update_heart_values()

	intent_set.connect(on_intent_set)
	self.mouse_entered.connect(on_mouse_entered)
	self.mouse_exited.connect(on_mouse_exited)
