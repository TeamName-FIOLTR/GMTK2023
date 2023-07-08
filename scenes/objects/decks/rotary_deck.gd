extends Node2D
class_name RotaryDeck


@export var discard_pile : CardPile 
@export var draw_pile : CardPile


func purge_card(c : Card)->void:
	card_deck.remove(c)
	draw_deck.remove(c)
	discard_deck.remove(c)

	if c.get_parent():
		c.get_parent().remove_child(c)

#send the card to the discard pile
func send_to_discard(c : Card):
	purge_card(c)
	discard_deck.cards.append(c)
	update_cards_on_rotary()

func send_to_hand(c):
	purge_card(c)
	card_deck.cards.append(c)
	c.card_box = self 
	update_cards_on_rotary()
	c.update_display()
	c.flip_up()


func send_to_draw(c):
	purge_card(c)
	draw_deck.cards.append(c)
	update_cards_on_rotary()



#remove all used cards
func clean()->void:
	for c in $card_timeout.get_children():
		discard_pile.take_card(c)
		send_to_discard(c)
	update_cards_on_rotary()

@export var focused_card_position : Node2D

#represents the card that is currently selected
var selected_card : Card : 
	set (val):
		if val and val == selected_card:
			val.reset_position()
			selected_card = null 
		else:
			if selected_card:
				selected_card.reset_position()
			selected_card = val 
			if selected_card:
				selected_card.tween_to(focused_card_position.global_position,10/60.0,"global_position")
	get:
		return selected_card


@onready var rotary_path : Path2D = $Path2D:
	set(n_path):
		print("oooo setget")
		rotary_path = n_path
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

@export var rotart_sensativity : float = 5

@export var card_deck : Deck

var draw_deck : Deck 
var discard_deck : Deck



@export var scroll : float = 0

@export var card_scale : float = 1.0



var card_offsets : Array[float]

# Called when the node enters the scene tree for the first time.

#prevents the given card from spining with the roter,
#note as of CURRENTLY this cannot be undone, so don't use
#it if you need to undo it
func ground_card(card : Card)->void:
	var gp = card.global_position 
	card.scale *= card.get_parent().scale
	card.get_parent().remove_child(card)
	$card_timeout.add_child(card)
	card.global_position = gp
	pass
	
func update_rotary_path():
	if not is_inside_tree(): return
	if rotary_path == null:
		print("ugh i love godot")
		print(rotary_path)
		return
	var curve = rotary_path.curve
	curve.clear_points()
	curve.add_point(Vector2(-rotary_width,rotary_height),Vector2.ZERO,edge_handles)
	curve.add_point(Vector2.ZERO,center_handle,center_handle*Vector2(-1,1))
	curve.add_point(Vector2(rotary_width,rotary_height),edge_handles*Vector2(-1,1), Vector2.ZERO)
	pass

#moves the given card to the discard pile
func discard(card : Card)->void:
	send_to_discard(card)

func discard_random(amount: int = 1)->void:
	for i in range(amount):
		var to_discard = card_deck.get_random()
		if to_discard:
			discard(to_discard)

#draws n cards
func draw_card(amount : int = 1)->void:
	for i in range(amount):
		if len(draw_deck.cards) > 0:
			send_to_hand(draw_deck.cards[0])
		else:
			break 
func _ready():
	update_rotary_path()
	
	card_deck = Deck.new()
	discard_deck = Deck.new()
	draw_deck = Deck.new()

	for c in draw_pile.get_children():
		draw_deck.cards.append(c)

	#draw a starting hand of 4 cards
	draw_card(4)

	for c in card_deck.cards:
		c.card_box = self
	
	update_cards_on_rotary()

func update_cards_on_rotary():
	for child in rotary_path.get_children():
		child.remove_child(child.get_child(0)) #we delete the rotary NOT the card
		child.queue_free()
	var card_count = card_deck.cards.size()
	
	card_offsets.resize(card_count)

	
	var i = 0 # POV: no enumerate()
	for card in card_deck.cards:
		var follower = PathFollow2D.new()
		follower.add_child(card)
		rotary_path.add_child(follower)
		follower.scale = Vector2.ONE*card_scale
		
		card_offsets[i] = i/float(card_count)
		i += 1
	for card in card_deck.cards:
		card.update_display()
	
	update_scroll()

func update_scroll():
	self.selected_card = null
	var following_points = rotary_path.get_children()
	for i in range(len(card_deck.cards)):
		following_points[i].progress_ratio = clamp(card_offsets[i]+scroll,0.001,0.999)
	pass

func _on_click_area_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		print("/")
		if abs(event.relative.x)>abs(event.relative.y):
			scroll += clamp(event.relative.x/1000.0*self.rotart_sensativity,-0.5,1.5)
			update_scroll()
	pass # Replace with function body.
