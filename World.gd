extends Node2D


# Declare member variables here. Examples:
onready var Civilization = preload("res://Civilization.gd")

var civ_colors = [
	Color(1.0, 0, 1.0),
	Color(0.12, 0.56, 1.0),
	Color(0, 1.0, 0)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	var planets = get_tree().get_nodes_in_group("planets")
	
	for i in range(3):
		var civ = Civilization.new()
		civ.color = civ_colors[i]
		civ.spawn_on(planets[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
