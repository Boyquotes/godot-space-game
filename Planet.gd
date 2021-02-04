extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const rot_speed = PI / 6
var orbit_speed = PI / rand_range(24, 36)
var orbit_angle = rand_range(0, 2 * PI)
var orbit_distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("celestial-bodies")
	var relation = self.global_position - self.get_parent().global_position
	orbit_distance = relation.length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rot_speed * delta
	
	orbit_angle += orbit_speed * delta
	position = Vector2(orbit_distance, 0).rotated(orbit_angle)
