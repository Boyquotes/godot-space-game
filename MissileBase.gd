extends "res://Structure.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var nearby_enemies = []
var target = null

onready var shootpoints = get_node("Barrel/Shootpoints").get_children()
onready var Laser = preload("res://Laser.tscn")
onready var Torpedo = preload("Torpedo.tscn")
onready var world = get_tree().get_root().get_node("World")

var rot_speed = PI / 3
var rot_range = PI / 2
var laser_speed = 700

const fire_rate = 0.2
var time_since_last_shot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nearby_enemies.size() > 0:
		var closest = nearby_enemies[0]
		var closest_dist = INF
		for b in nearby_enemies: 
			var d = global_position.distance_to(closest.global_position)
			if d < closest_dist:
				closest = b
				closest_dist = d
		target = closest
	else:
		target = null
	
	if target != null:
		var to_target = global_position - target.global_position
		
		# rotate towards target
		var desired_angle = fposmod(to_target.angle() + PI, PI * 2) + PI / 2
		var desired_rot = short_angle_dist($Barrel.global_rotation, desired_angle)
		
		if abs(desired_rot) > PI / 32:
			$Barrel.rotation += sign(desired_rot) * rot_speed * delta
			$Barrel.rotation = clamp($Barrel.rotation, -rot_range / 2, rot_range / 2)
		
		shoot(delta)

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
	
func shoot(delta):
	time_since_last_shot += delta
		
	if time_since_last_shot < fire_rate:
		return
	elif time_since_last_shot >= fire_rate:
		time_since_last_shot = 0
	
	for shootpoint in shootpoints:
		var spawn = world.get_laser()
		spawn.global_position = shootpoint.global_position
		spawn.rotation = self.global_rotation + $Barrel.rotation - PI / 2
		spawn.vel = Vector2(laser_speed, 0).rotated(spawn.global_rotation)
		spawn.origin = self
		spawn.add_collision_exception_with(self)
	
		get_tree().get_root().get_node("World").add_child(spawn)
	
func set_color(color):
	$Body.color = color
	$Barrel/ColorRect.color = color
	$Barrel/ColorRect2.color = color
	

func _on_DetectionZone_body_entered(body):
	if get_parent().civ.is_enemy(body):
		nearby_enemies.append(body)


func _on_DetectionZone_body_exited(body):
	if body in nearby_enemies:
		nearby_enemies.erase(body)
