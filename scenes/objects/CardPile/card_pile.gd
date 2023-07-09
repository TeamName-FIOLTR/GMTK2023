extends Node2D

class_name CardPile 

#pulls a card to our location
func take_card(card : Card):
	#ensure that the card will not display dice when we take it
	card.get_parent().remove_child(card)
	add_child(card)
	card.flip_down()
	card.tween_to(global_position,6.0/60,"global_position")
	card.pos_tween.finished.disconnect(card.display_dice)
	card.pos_tween.finished.connect(on_card_arrived.bind("card",card))



func on_card_arrived(card):
	pass
	#print(card.name + " has arrived")
