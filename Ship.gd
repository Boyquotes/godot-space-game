extends KinematicBody2D

onready var Laser = preload("Laser.tscn")

const acc = 300
const dec = 150
const max_speed = 400
const rot_speed = PI

const heat_max = 100
const reg_vent_rate = 30
const heat_per_shot = 10
var heat = 0
var venting = false

# heat_per_shot / fire_rate should be > reg_vent_rate
const fire_rate = 0.1
var time_since_last_shot = 0

var health = 100

var vel = Vector2(0 ,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_heat(delta)
	limit_speed()
	move_and_collide(vel * delta)

func limit_speed():
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
		
func thrust(delta):
	vel += Vector2(acc * delta, 0).rotated(rotation)
	
func reverse(delta):
	vel -= Vector2(dec * delta, 0).rotated(rotation)

func update_heat(delta):
	if heat >= heat_max:
		venting = true
		heat = heat_max
	elif heat <= 0:
		venting = false
		heat = 0
	
	if venting:
		heat -= reg_vent_rate * 2 * delta
	else:
		heat -= reg_vent_rate * delta

func shoot(delta):
	time_since_last_shot += delta
	if venting:
		return
		
	if time_since_last_shot < fire_rate:
		return
	elif time_since_last_shot >= fire_rate:
		time_since_last_shot = 0
	
	heat += heat_per_shot
	
	var spawn = Laser.instance()
	spawn.global_position = $ShootPoint.global_position
	spawn.rotation = self.global_rotation	
	spawn.vel = Vector2(self.max_speed + 200, 0).rotated(spawn.global_rotation)
	spawn.add_collision_exception_with(self)
	
	get_parent().add_child(spawn)
	
func take_hit(strength):
	health -= strength
	if health <= 0:
		queue_free()


