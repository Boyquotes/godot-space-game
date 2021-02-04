extends KinematicBody2D


# Declare member variables here. Examples:

onready var Structure = preload("res://Structure.tscn")

const rot_speed = PI / 6
var orbit_speed = PI / rand_range(24, 36)
var orbit_angle = rand_range(0, 2 * PI)
var orbit_distance = 0

const radius = 170

var resources = 0
var availabe_structure_spots = range(16)
var structures = []

var civ = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("celestial-bodies")
	add_to_group("planets")
	var relation = self.global_position - self.get_parent().global_position
	orbit_distance = relation.length()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rot_speed * delta
	
	orbit_angle += orbit_speed * delta
	position = Vector2(orbit_distance, 0).rotated(orbit_angle)

func random_structure_angle():
	var index = rand_range(0, availabe_structure_spots.size())
	var spot = availabe_structure_spots[index]
	availabe_structure_spots.remove(index)
	return spot * PI / 8

func add_structure(angle):
	var struct = Structure.instance()
	struct.position = Vector2(radius, 0).rotated(angle)
	struct.rotation = angle
	struct.z_index = -1
	structures.append(struct)
	struct.set_color(civ.color)
	add_child(struct)
	
func set_controlling_civ(controller):
	civ = controller
	for s in structures:
		s.set_color(civ.color)
