extends "res://Structure.gd"


# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("structures")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color(color):
	for rect in $Rects.get_children():
		rect.color = color

	
