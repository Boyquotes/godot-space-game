extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var acc = 100
var max_speed = 300
const lifelength = 5
var age = 0
var origin = null
var target = null

var rot_speed = PI / 6

var world = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vel += Vector2(acc * delta, 0).rotated(global_rotation)
	
	age += delta
	
	if target != null:
		var to_target = global_position - target.global_position
		# rotate towards target
		var desired_angle = fposmod(to_target.angle() + PI, PI * 2)
		var desired_rot = short_angle_dist(rotation, desired_angle)
		
		if abs(desired_rot) > PI / 32:
			var diff = sign(desired_rot) * rot_speed * delta
			rotation += diff
			vel = vel.rotated(diff)
	
	var collision = move_and_collide(self.vel * delta)
	if collision != null:
		if collision.collider.get("health") != null:
			collision.collider.take_hit(100, origin)	
		queue_free()
	
	if age >= lifelength:
		queue_free()
		
func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
		
func disable():
	age = 0
	world.laser_pool.append(self)
	get_parent().remove_child(self)
	remove_collision_exception_with(origin)
	global_position = Vector2(50000, 50000)


func _on_DetectionZone_body_entered(body):
	if origin != null:
		if origin.get("civ") == body.get("civ"):
			return
	
	var new_target = null
	# do we need a target still?
	if target == null:
		new_target = body
	# is it closer?
	elif global_position.distance_to(body.global_position) < global_position.distance_to(target.global_position):
		new_target = body
	else:
		return
		
	# update torpedo alerts
	if target != null:
		target.torpedo_alert = null
	target = new_target
	new_target.torpedo_alert = self
		
