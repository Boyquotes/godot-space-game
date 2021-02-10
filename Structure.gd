extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health = 300.0
var civ = null

var torpedo_alert = null

# Called when the node enters the scene tree for the first time.
func _ready():
	civ = get_parent().civ


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_hit(strength, origin):
	# we forgive them if they die. Also helps with errors
	if origin == null:
		return
	
	if origin.get("civ") != get_parent().civ:
		health -= float(strength)
	if health <= 0:
		queue_free()
