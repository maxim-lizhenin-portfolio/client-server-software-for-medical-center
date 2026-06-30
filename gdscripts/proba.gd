extends Control

@onready var dct = {"state": {"myaw": [1,2,3]},
"state1": {"myaw": [4,5,6]}}

func _ready():
	for d in dct:
		for m in dct[d]:
			print(dct[d][m])
	
