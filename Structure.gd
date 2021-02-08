extends KinematicBody2D


# Declare member variables here. Examples:

var health = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("structures")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color(color):
	for rect in $Rects.get_children():
		rect.color = color
		
func take_hit(strength, origin):
	if origin.get("civ") != get_parent().civ:
		health -= float(strength)
	if health <= 0:
		queue_free()
	
