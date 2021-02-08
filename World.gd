extends Node2D

# Declare member variables here. Examples:
onready var Civilization = preload("res://Civilization.gd")

const consonants = "BCDFGHJKLMNPQRSTVWXZ"
const vowels = "AEIOUY"
const suffixes = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'IX', 'X']

var used_names = []

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
	
	if planets.size() == 0:
		return
	
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
		p.get_node("Label").bbcode_text = "[center]" + random_name() + "[/center]"
		if p.civ != null:
			p.spawn_ship()
			p.spawn_ship()
			p.spawn_ship()
			
func random_choice(iterable):
	if typeof(iterable) == typeof(""):
		return iterable[randi() % iterable.length()]
	else:
		return iterable[randi() % iterable.size()]
			
func random_syllable():
	return (random_choice(consonants) 
			+ random_choice(vowels) 
			+ random_choice(consonants + vowels))

func random_name():
	var name = random_syllable() + random_syllable() + " " + random_choice(suffixes)
	if name in used_names:
		return random_name()
	return name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
