extends Resource

class_name EntityStats

@export
var hp : int = 20 #how much damage it can take
@export
var ac : int = 10 #how hard it is to hit

@export var attack = 2
@export var defence = 1

@export
var actions : Array[int] = [35,35,25,5]



#returns a wieghted selection using
#the values in the array as weights
func get_action()->int:
	var roll : int = randi() % 100
	for v in range(len(actions)):
		if roll < actions[v]:
			return v
		roll -= actions[v]
	return 0
			
