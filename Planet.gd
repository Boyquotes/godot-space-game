extends KinematicBody2D


# Declare member variables here. Examples:

onready var Structure = preload("res://Structure.tscn")
onready var AIShip = preload("res://AIShip.tscn")
onready var DebugMarker = preload("res://DebugMarker.tscn")

var rot_speed = 0#PI / rand_range(4, 8)
var orbit_speed = 0#PI / rand_range(24, 36)
var orbit_angle = 0#rand_range(0, 2 * PI)
var orbit_distance = 0

# draw parameters
const min_stripe_size = 8
const max_stripe_size = 30
const color_change = 0.1

const radius = 120

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
	
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count("default")
	
	rot_speed = PI / rand_range(4, 8)
	orbit_speed = PI / rand_range(48, 72)
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

#func _draw():
#	# draw planet
#
#	var y_increase = 5
#	var y = -radius
#	var x = -radius
#	var w = 2 * radius
#	var color = Color(
#		rand_range(0, 1),
#		rand_range(0, 1),
#		rand_range(0, 1)		
#	)
#	while y < radius:
#		var h = rand_range(min_stripe_size, max_stripe_size)
#		color = shifted_color(color)
#
#		for i in range(0, h, y_increase):
#			#layer_polygon(y, h, color)
#			y += y_increase
#
#		# create polygon
##		var rect = Rect2(Vector2(x, y), Vector2(w, h))
##		draw_rect(rect, color)
##		y += h
	
func circle_y_to_xs(y, r):
	var x = sqrt(pow(r, 2) - pow(y, 2))
	return [x, -x]
	
func get_circumference(r):
	return PI * (r * 2) #πd
	
func arc_length_from_angle(angle, r):
	return (angle / (PI * 2)) * get_circumference(r)
	
func layer_polygon(y, h, color):
	var center = Vector2(0, 0)
	var stripe_top = y
	var stripe_bottom = y + h
	
	# calculate corners
	var top_xs = circle_y_to_xs(stripe_top, radius)
	var bottom_xs = circle_y_to_xs(stripe_bottom, radius)
	
	var topright = Vector2(top_xs[0], stripe_top)
	var topleft = Vector2(top_xs[1], stripe_top)
	var bottomright = Vector2(bottom_xs[0], stripe_bottom)
	var bottomleft = Vector2(bottom_xs[1], stripe_bottom)
	
	# draw that
	var points = PoolVector2Array([
		topright,
		topleft,
		bottomleft,
		bottomright
	])
	var colors = PoolColorArray([color])
	draw_polygon(points, colors)
	
#	# calculate angles, arc length, and number of points
#	var angle_a = center.angle_to_point(bottomright)
#	var angle_b = center.angle_to_point(topright)
#	var angle_diff = abs(angle_a - angle_b)
#	var arc_length = arc_length_from_angle(angle_diff, radius)
#	var nb_points: int = (arc_length / get_circumference(radius)) * 128
#
#	# begin polygon
#	var points = PoolVector2Array()
#	points.push_back(center)
#	var colors = PoolColorArray([color])
#
#	# calculate left arc points. From a to b
#	for i in range(nb_points + 1):
#		var angle_point = angle_a + i * (angle_b - angle_a) / nb_points - PI / 2
#		points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#	# reflect angles across y-axis
#	angle_a = PI - angle_a
#	angle_b = PI - angle_b
#
#	# go to right arc. From b to a
#	points.push_back(topleft)
#	for i in range(nb_points + 1):
#		var angle_point = angle_b + i * (angle_a - angle_b) / nb_points - PI / 2
#		points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#	# finally, draw it all
#	draw_polygon(points, colors)
	
func limited(v, _min=0.1, _max=1):
	return max(min(v, _max), _min)
	
func shifted_color(color):
	var shift = rand_range(-color_change, color_change)
	return Color(
		limited(color.r + shift),
		limited(color.g + shift),
		limited(color.b + shift)
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rot_speed * delta
	
	$Shadow.look_at(get_parent().global_position)
	
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
