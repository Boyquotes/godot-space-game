extends Node2D


# Declare member variables here. Examples:
onready var Civilization = preload("res://Civilization.gd")

var civ_colors = [
	Color(1.0, 0, 1.0),
	Color(0.12, 0.56, 1.0),
	Color(0, 1.0, 0),
	Color(1.0, 1.0, 0),
	Color(1.0, 0.65, 0),
	Color(0.6, 0, 1.0)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var map_seed = randi()
	seed(map_seed)
	
	
	yield(get_tree(), "idle_frame")
	var planets = get_tree().get_nodes_in_group("planets")
	planets.shuffle()
	
	var reputation_graph = $PlayerShip/CanvasLayer/ReputationGraph
	for i in range(6):
		var civ = Civilization.new()
		civ.player = get_node("PlayerShip")
		civ.color = civ_colors[i]
		civ.spawn_on(planets[i])
		reputation_graph.add_civ(civ)
	reputation_graph.create_bars()
	
	# TODO: figure out why these yields are needed
	yield(get_tree(), "idle_frame")
	for p in planets:	
		if p.civ != null:
			p.spawn_ship()
			p.spawn_ship()			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
