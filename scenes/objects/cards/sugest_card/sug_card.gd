extends Card

class_name SugCard

@export var suggestion_intent : Entity.Intent = Entity.Intent.EMPTY
@export var increase_amount : int = -100

func play_effect(_decks : RotaryDeck,_entity : Entity):
	if suggestion_intent != Entity.Intent.EMPTY:
		_entity.stats.actions[suggestion_intent] += increase_amount
		for i in range(len(_entity.stats.actions)):
			if i != suggestion_intent:
				_entity.stats.actions[i] -= increase_amount / 3
	super.play_effect(_decks,_entity)

func update_display():
	#print("updating display for " + str(name))
	super.update_display()
	#make sure the rules text matches the cards type
	rules_text.text = "suggest\n" +\
		Entity.intent2str(self.suggestion_intent) +\
		"+" +\
		str(self.increase_amount) + "%"
