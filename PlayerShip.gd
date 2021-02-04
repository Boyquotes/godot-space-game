extends KinematicBody2D


onready var Laser = preload("Laser.tscn")


const acc = 300
const dec = 150
const max_speed = 400
const rot_speed = PI

var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("forward"):
		thrust(delta)
	elif Input.is_action_pressed("backward"):
		reverse(delta)
	
	if Input.is_action_pressed("left"):
		rotation -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rotation += rot_speed * delta
		
	if Input.is_action_pressed("shoot"):
		shoot()
	
	move_and_collide(vel * delta)
	self.limit_speed()
	
func thrust(delta):
	vel += Vector2(acc * delta, 0).rotated(rotation)
	
func reverse(delta):
	vel -= Vector2(dec * delta, 0).rotated(rotation)
	
func shoot():
	var spawn = Laser.instance()
	spawn.global_position = $ShootPoint.global_position
	spawn.rotation = self.global_rotation	
	spawn.vel = Vector2(self.max_speed + 200, 0).rotated(spawn.global_rotation)
	spawn.add_collision_exception_with(self)
	
	get_parent().add_child(spawn)
	
func limit_speed():
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
	
