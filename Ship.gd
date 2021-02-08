extends KinematicBody2D

onready var Laser = preload("Laser.tscn")

const acc = 175
const dec = 160
const max_speed = 300
const rot_speed = PI

const max_heat = 100
const reg_vent_rate = 30
var heat_per_shot = 10
var heat = 0
var venting = false

const max_shield = 100
var shield = 50

var color = Color(1.0, 1.0, 1.0)

# heat_per_shot / fire_rate should be > reg_vent_rate
const fire_rate = 0.1
var time_since_last_shot = 0

const max_health = 100.0
var health = 100.0

var vel = Vector2(0 ,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_heat(delta)
	limit_speed()
	move_and_collide(vel * delta)
	
func _draw():
	var points = [
		Vector2(	-18, 13),
		Vector2(-13, 0),
		Vector2(-18, -13),
		Vector2(18, 0)			
	]
	var colors = PoolColorArray([self.color])
	draw_polygon(PoolVector2Array(points), colors)
	
	create_collision_polygon(points)
	move_shoot_point_to(points[-1])
	
func create_collision_polygon(points):
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = points
	add_child(collision_shape)
	
func move_shoot_point_to(point):
	get_node("ShootPoint").position = point
	
func change_color(new_color):
	self.color = new_color
	update()

func limit_speed():
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
		
func thrust(delta):
	vel += Vector2(acc * delta, 0).rotated(rotation)
	
func reverse(delta):
	vel -= Vector2(dec * delta, 0).rotated(rotation)

func update_heat(delta):
	if heat >= max_heat:
		venting = true
		heat = max_heat
	elif heat <= 0:
		venting = false
		heat = 0
	
	if venting:
		heat -= reg_vent_rate * 2 * delta
	else:
		heat -= reg_vent_rate * delta
		
func get_as_percent(value):
	var at = get(value)
	var maximum = get("max_" + value)
	return (at / maximum) * 100

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
	spawn.vel = Vector2(self.max_speed + 100, 0).rotated(spawn.global_rotation)
	spawn.origin = self
	spawn.add_collision_exception_with(self)
	
	get_parent().add_child(spawn)
	
func take_hit(strength, origin):
	handle_attack_from(origin)
	health -= float(strength)
	if health <= 0:
		queue_free()

func handle_attack_from(origin):
	pass
