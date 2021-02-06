extends KinematicBody2D


# Declare member variables here. Examples:

onready var Structure = preload("res://Structure.tscn")
onready var AIShip = preload("res://AIShip.tscn")
onready var DebugMarker = preload("res://DebugMarker.tscn")

var rot_speed = 0#PI / rand_range(4, 8)
var orbit_speed = 0#PI / rand_range(24, 36)
var orbit_angle = 0#rand_range(0, 2 * PI)
var orbit_distance = 0

const radius = 170

var resources = 0
var availabe_structure_spots = range(16)
var structures = []

var surrounding_points = []
const num_surrounding_points = 3
const surrounding_point_distance = 100 + radius

var civ = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var map_seed = randi()
	seed(map_seed)
	
	$AnimatedSprite.frame = randi() % 3
	
	rot_speed = PI / rand_range(4, 8)
	orbit_speed = PI / rand_range(24, 36)
	orbit_angle = rand_range(0, 2 * PI)
	
	add_to_group("celestial-bodies")
	add_to_group("planets")
	var relation = self.global_position - self.get_parent().global_position
	orbit_distance = relation.length()
	
	create_surrounding_points()
	
func create_surrounding_points():
	var unit_angle = 2 * PI / num_surrounding_points
	for i in range(num_surrounding_points):
		var angle = unit_angle * i
		var point = Vector2(surrounding_point_distance, 0).rotated(angle)
		var pos = Position2D.new()
		pos.position = point
		add_child(pos)
		surrounding_points.append(pos)
	
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
	
func spawn_ship():
	# TODO: spawn in planet so it gets forced exactly to surface
	var position_index = randi() % num_surrounding_points
	var position_node = self.surrounding_points[position_index]
	var spawn = AIShip.instance()
	var offset = Vector2(rand_range(-50, 50), rand_range(-50, 50))
	spawn.global_position = position_node.global_position + offset
	spawn.operational_target = position_node
	spawn.change_color(civ.color)
	spawn.civ = civ
	get_tree().get_root().add_child(spawn)
	
func set_controlling_civ(controller):
	civ = controller
	for s in structures:
		s.set_color(civ.color)
