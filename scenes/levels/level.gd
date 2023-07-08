extends Control

@export var entity_container : EntityContainer
@export var talkBox : TalkBox 
@export var handContainer : RotaryDeck

var scene_text : String = ""

#keeps track of how many entities that we
#have applied a number to
var entities_with_rolls : int = 0


#runs all the code necessary for updating the scene
#for the next stage of the game
func update_scene()->void:
	handContainer.clean()	
	entity_container.set_intents()
	scene_text = entity_container.get_state_text()
	talkBox.clear_text()
	talkBox.target_text = scene_text
	entities_with_rolls = 0

#array of functional effects to apply to cards
var round_effects  = []
var long_effects = [] 


func apply_effects(x : int)->int:
	for ef in round_effects:
		x = ef.call(x)
	for ef in long_effects:
		x = ef.call(x)
	return x

func evaluate_entities():
	for e in entity_container.get_children():
		if e.has_method("attempt"):
			e.attempt()
			e.next_roll = -1

func on_entity_selected(entity):
	if entity.next_roll == -1 and handContainer.selected_card:
		var sc = handContainer.selected_card
		handContainer.ground_card(sc)
		handContainer.selected_card = null
		sc.tween_to(entity.roll_display.global_position,6.0/60,"global_position")
		entity.next_roll = apply_effects(sc.number)
		sc.pos_tween.finished.connect(sc.display_dice)
		entities_with_rolls += 1
		print(entities_with_rolls)
		if entities_with_rolls >= entity_container.get_desired_rolls():
			evaluate_entities()


# Called when the node enters the scene tree for the first time.
func _ready():
	entity_container.entity_selected.connect(on_entity_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("developer_debug"):
		update_scene()
