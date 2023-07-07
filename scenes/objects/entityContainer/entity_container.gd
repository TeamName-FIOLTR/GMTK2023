extends Node2D


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
	print(dir)
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
