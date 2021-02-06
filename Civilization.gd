extends Node


# Declare member variables here. Examples:
var color = Color(1.0, 1.0, 1.0)

var planets = []
var relationship_with_player = 0
var foreign_relations = {}

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_on(planet):
	planets.append(planet)
	planet.set_controlling_civ(self)
	
	for i in range(4):
		planet.add_structure(planet.random_structure_angle())

func is_enemy(body):
	if body == player:
		return relationship_with_player < 0
	
	if body.get("civ") == null:
		return false
		
	if body.civ == self:
		return false
