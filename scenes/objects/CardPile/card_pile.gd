extends Node2D

class_name CardPile 

var deck : Deck

@export var card_scale : Node2D

#pulls a card to our location
func take_card(card : Card):
	#ensure that the card will not display dice when we take it
	var gp : Vector2 = card.global_position 
	var gs : Vector2 = card.global_scale
	card.get_parent().remove_child(card)
	card_scale.add_child(card)
	card.global_position = gp
	card.global_scale = gs
	card.visible = false
	card.flip_down()
	card.tween_to(global_position,6.0/60,"global_position")
	card.pos_tween.finished.disconnect(card.display_dice)
	card.pos_tween.finished.connect(on_card_arrived.bind("card",card))

func on_card_arrived(card):
	print(card.name + " has arrived")
# Called when the node enters the scene tree for the first time.
func _ready():
	deck = Deck.new()


