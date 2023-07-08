extends Control

@export var entity_conainer : EntityContainer
@export var talkBox : TalkBox 
@export var handContainer : RotaryDeck

var scene_text : String = ""

#keeps track of how many entities that we
#have applied a number to
var entities_with_rolls : int = 0
#runs all the code necessary for updating the scene
#for the next stage of the game
func update_scene()->void:
	entity_conainer.set_intents()
	scene_text = entity_conainer.get_state_text()
	talkBox.clear_text()
	talkBox.target_text = scene_text

func apply_effects(x : int)->int:
	return x

func evaluate_entities():
	for e in get_children():
		if e.has_method("attempt"):
			e.attempt()
			e.next_roll = -1

func on_entity_selected(entity):
	print(entity.next_roll)
	if entity.next_roll == -1 and handContainer.selected_card:
		var sc = handContainer.selected_card
		handContainer.ground_card(sc)
		handContainer.selected_card = null
		sc.tween_to(entity.global_position,6.0/60,"global_position")
		entity.next_roll = apply_effects(sc.number)

		entities_with_rolls += 1
		if entities_with_rolls >= get_child_count():
			evaluate_entities()


# Called when the node enters the scene tree for the first time.
func _ready():
	entity_conainer.entity_selected.connect(on_entity_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("developer_debug"):
		update_scene()
