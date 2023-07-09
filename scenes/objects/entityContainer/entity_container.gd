extends Node2D

class_name EntityContainer

signal entity_selected

#returns the number of rolls that we need to supply for the game to run
func get_desired_rolls()->int:
	var ret_val : int = 0
	for c in get_children():
		if c.requires_input:
			ret_val += 1
	return ret_val

#randomizes the intents of all entities under the container
func set_intents()->void:
	for c in get_children():
		if c.has_method("make_intent"):
			c.make_intent()
			c.hide_dc()
			c.roll_display.visible = false 
			c.clear_residuals()
func _ready():
	entity_selected.connect(on_entity_select)
func on_entity_select(en)->void:
	#print(en.name)
	pass
func get_state_text()->String:
	var ret_val : String = ""
	for c in get_children():
		if c.has_method("describe_intent"):
			ret_val += c.describe_intent() + "\n" 
	
	var filler : Array[String] = ["?"]
	filler.resize(get_child_count())
	for i in range(len(filler)):
		filler[i] = "?"

	return ret_val % filler

#represents the entity that this container has selected
var selected_entity : Entity = null :
	set(val):
		if val != selected_entity:
			if selected_entity:
				selected_entity.on_focus_exit()
			val.on_focus_enter()
		selected_entity = val 
	get:
		return selected_entity

func set_focused_entity(e : Entity):
	selected_entity = e

func sigmoid(x : float)->float:
	var v = exp(x)
	return v / (v+1)

func _input(event)->void:
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir:
		var target_position : Vector2 = Vector2(0,0)
		if selected_entity:
			target_position = selected_entity.position
		var clossest = selected_entity 
		var distance = 999999
		for c in self.get_children():
			if c != selected_entity:
				var offset_vector = c.position - target_position
				var d = dir.distance_squared_to((offset_vector).normalized())
				if distance > d:
					distance = d
					clossest = c
		self.selected_entity = clossest
