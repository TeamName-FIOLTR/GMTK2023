extends Control

@export var entity_conainer : EntityContainer
@export var talkBox : TalkBox

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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("developer_debug"):
		update_scene()
