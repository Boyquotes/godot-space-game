extends Node2D

# Declare member variables here. Examples:
onready var Civilization = preload("res://Civilization.gd")
onready var Star = preload("res://Star.tscn")
onready var Laser = preload("res://Laser.tscn")

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

var laser_pool = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var map_seed = randi()
	seed(map_seed)
	
	for i in range(6):
		var star = Star.instance()
		star.starname = random_name()
		add_child(star)
		star.position.x = i * 5000
		yield(get_tree(), "idle_frame")
		
		
	var stars = get_tree().get_nodes_in_group("stars")
	
	$PlayerShip.global_position = stars[0].global_position + Vector2(300, 300)
		
	
	var planets = get_tree().get_nodes_in_group("planets")
	planets.shuffle()
	
	
	if planets.size() == 0:
		return
	
	var reputation_graph = $PlayerShip/CanvasLayer/ReputationGraph
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
		
	for i in range(civ_colors.size()):
		var civ = Civilization.new()
		civ.player = get_node("PlayerShip")
		civ.color = civ_colors[i]
		
		for p in stars[i].planets:
			civ.spawn_on(p)
				
		reputation_graph.add_civ(civ)
	
	reputation_graph.create_bars()
	
	# TODO: figure out why these yields are needed
	yield(get_tree(), "idle_frame")
	for p in planets:
		p.get_node("Label").bbcode_text = "[center]" + random_name() + "[/center]"
		if p.civ != null:
			for i in range(2):
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

func get_laser():
	var l = laser_pool.pop_front()
	if l == null:
		l = Laser.instance()
		l.world = self
	l.visible = true
	return l


func _on_Timer_timeout():
	for p in get_tree().get_nodes_in_group("planets"):
		pass#p.spawn_ship()
