extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Planet = preload("Planet.tscn")

const orbit_length = 700
const num_planets = 3
var radius = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.radius = $CollisionShape2D.shape.radius
	for i in range(num_planets):
		var p = Planet.instance()
		p.position.x = (i + 1) * orbit_length + self.radius
		add_child(p)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func draw_circle_arc(center, radius, angle_from, angle_to, color, pts=32):
	var nb_points = pts
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
		
func _draw():
	draw_circle(Vector2(0, 0), self.radius, Color(1.0, 1.0, 0.0))
	
	# draw orbits
	for i in range(num_planets):
		draw_circle_arc(Vector2(0, 0), orbit_length * (i + 1) + self.radius, 0, 360, Color(0.3, 0.3, 0.3), 50)
