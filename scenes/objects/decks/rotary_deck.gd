@tool
extends Node2D
class_name RotaryDeck

@onready var rotary_path : Path2D = $Path2D:
	set(n_path):
		print("oooo setget")
#		print(n_path)
#		print(rotary_path)
		rotary_path = n_path
#		print(rotary_path)
		update_rotary_path()

@export var rotary_width : float = 100:
	set(n_rotary_width):
		print("lol")
		rotary_width = n_rotary_width
		update_rotary_path() # all with a multi cursor operation btw

@export var rotary_height : float = 50:
	set(n_rotary_height):
		rotary_height = n_rotary_height
		update_rotary_path() # all with a multi cursor operation btw

@export var edge_handles : Vector2 = Vector2(0,0):
	set(n_edge_handles):
		edge_handles = n_edge_handles
		update_rotary_path() # all with a multi cursor operation btw

@export var center_handle : Vector2 = Vector2(100,0):
	set(n_center_handle):
		center_handle = n_center_handle
		update_rotary_path() # all with a multi cursor operation btw

@export var card_deck : Deck

@export var scroll : float = 0

var card_offsets : Array[float]

# Called when the node enters the scene tree for the first time.

func update_rotary_path():
#	print("urmum")
#	print(rotary_path)
	if not is_inside_tree(): return
	if rotary_path == null:
		print("ugh i love godot")
		print(rotary_path)
		return
#	print("so that works")
	var curve = rotary_path.curve
	curve.clear_points()
	curve.add_point(Vector2(-rotary_width,rotary_height),Vector2.ZERO,edge_handles)
	curve.add_point(Vector2.ZERO,center_handle,center_handle*Vector2(-1,1))
	curve.add_point(Vector2(rotary_width,rotary_height),edge_handles*Vector2(-1,1), Vector2.ZERO)
	pass



func _ready():
	card_deck = Deck.new()
	var card : PackedScene= load("res://scenes/objects/cards/card.tscn")
	card_deck.cards.append_array([card.instantiate(),card.instantiate(),card.instantiate(),card.instantiate(),card.instantiate(),card.instantiate()])
	update_cards_on_rotary()
	pass # Replace with function body.

func update_cards_on_rotary():
	for child in rotary_path.get_children():
		child.queue_free()
	var card_count = card_deck.cards.size()
	card_offsets.resize(card_count)
	
	var i = 0 # POV: no enumerate()
	for card in card_deck.cards:
		var follower = PathFollow2D.new()
		follower.add_child(card)
		rotary_path.add_child(follower)
		
		card_offsets[i] = i/float(card_count)
		i += 1
		

func update_scroll():
	var following_points = rotary_path.get_children()
	for i in range(len(card_deck.cards)):
		following_points[i].progress_ratio = clamp(card_offsets[i]+scroll,0,1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_click_area_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		print("/")
		scroll += clamp(event.relative.x/1000.0,-0.5,1.5)
		update_scroll()
	pass # Replace with function body.
