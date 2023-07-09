extends Control

@export var entity_container : EntityContainer
@export var talkBox : TalkBox 
@export var handContainer : RotaryDeck

@export var turn_indicator : Label

var scene_text : String = ""

#keeps track of how many entities that we
#have applied a number to
var entities_with_rolls : int = 0


func game_over(message : String,seduced : bool)->void:
	Globals.game_over_message = message 
	Globals.seduced = seduced
	get_tree().change_scene_to_file("res://scenes/menus/game_over/game_over.tscn")


#runs all the code necessary for updating the scene
#for the next stage of the game
func update_scene()->void:
	turn_indicator.visible = false
	handContainer.clean()
	entity_container.set_intents()
	scene_text = entity_container.get_state_text()
	talkBox.clear_text()
	talkBox.target_text = scene_text
	entities_with_rolls = 0
	if len(handContainer.card_deck.cards) == 0:
		game_over("you ran out of cards!",false)

#array of functional effects to apply to cards
var round_effects  = []
var long_effects = [] 


func apply_effects(x : int)->int:
	for ef in round_effects:
		x = ef.call(x)
	for ef in long_effects:
		x = ef.call(x)
	return x


#this is the roll checking phase
func check_rolls()->void:
	for e in entity_container.get_children():
		if e.has_method("attempt"):
			e.ensure_roll() #make sure that we rolled SOMETHING, for the AI entities
			e.attempt()
			e.next_roll = -1
	
#this is the roll checking phase
func apply_damage()->void:
	for e in entity_container.get_children():
		if e.has_method("attempt"):
			e.apply_damage()


func evaluate_entities():
	check_rolls()
	apply_damage()
	turn_indicator.visible = true

func on_entity_selected(entity):
	if entity.next_roll == -1 and handContainer.selected_card:
		
		#clear out the card from the hand
		var sc = handContainer.selected_card
		handContainer.ground_card(sc)
		handContainer.selected_card = null 

		#animate the card so it looks purty
		sc.tween_to(entity.roll_display.global_position,6.0/60,"global_position")
		sc.pos_tween.finished.connect(sc.display_dice)

		#get the next roll for the card
		entity.next_roll = apply_effects(sc.number)
		print("calling card for " + str(sc.number))
		sc.on_play(handContainer,entity) #play the card effects
		
		#record that we played on an entity
		entities_with_rolls += 1
	
		#if we have given every entitied its desired rolls, evaluate the round
		if entities_with_rolls >= entity_container.get_desired_rolls():
			evaluate_entities()

func on_entity_die(_entity):
	if _entity.name == "knight":
		game_over("the slime killed the knight!",false)
	else:
		game_over("the knight killed the slime!",false)

func on_entity_seduce(who,whom)->void:
	game_over("%s seduced %s!" %[who.name,whom.name],true)

# Called when the node enters the scene tree for the first time.
func _ready():
	entity_container.entity_selected.connect(on_entity_selected)
	for c in entity_container.get_children():
		c.die.connect(on_entity_die)
		c.seduce.connect(on_entity_seduce)
	update_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("developer_debug") and turn_indicator.visible:
		update_scene()


func _on_rotary_deck_card_deselected(card):
	print("hceking card thingy")
	print(handContainer.selected_card)
	if handContainer.selected_card:
		entity_container.highlight_entities(true)
	else:
		entity_container.highlight_entities(false)
	pass # Replace with function body.


func _on_rotary_deck_card_selected(card):
	if handContainer.selected_card:
		entity_container.highlight_entities(true)
	else:
		entity_container.highlight_entities(false)
	pass # Replace with function body.
