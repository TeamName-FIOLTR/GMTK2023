extends Control

@export var entity_conainer : EntityContainer
@export var talkBox : TalkBox 
@export var handContainer : RotaryDeck

var scene_text : String = ""

#runs all the code necessary for updating the scene
#for the next stage of the game
func update_scene()->void:
	print("updating the scene!")
	entity_conainer.set_intents()
	scene_text = entity_conainer.get_state_text()
	print(scene_text)
	talkBox.clear_text()
	talkBox.target_text = scene_text
	print("scene_text")


func on_entity_selected(entity):
	if handContainer.selected_card:
		var sc = handContainer.selected_card
		handContainer.ground_card(sc)
		handContainer.selected_card = null
		sc.tween_to(entity.global_position,6.0/60,"global_position")

# Called when the node enters the scene tree for the first time.
func _ready():
	entity_conainer.entity_selected.connect(on_entity_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("developer_debug"):
		update_scene()
