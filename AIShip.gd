extends "res://Ship.gd"


# Declare member variables here. Examples:
var tactical_target = null # target to shoot at
var operational_target = null # target of strategic importance
var state = "defend" # relation to operational_target
var civ = null

var tactical_considerations = []

const defend_distance = 800

# Called when the node enters the scene tree for the first time.
func _ready():
	heat_per_shot = 20
	add_to_group("AI-ships")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = operational_target
	if tactical_target != null:
		target = tactical_target
	if torpedo_alert != null:
		target = evade_torpedo()

	var to_target = global_position - target.global_position
	
	var desired_rot = rotate_to_target(to_target, delta)
	fly_to_target(to_target, desired_rot, delta)
	handle_weapons(target, delta)
	
	if state == "defense":
		defend(target)
	elif state == "attack":
		pass
		
func rotate_to_target(to_target, delta):
	# rotate towards target
	var desired_angle = fposmod(to_target.angle() + PI, PI * 2)
	var desired_rot = short_angle_dist(rotation, desired_angle)
	
	if abs(desired_rot) > PI / 32:
		rotation += sign(desired_rot) * rot_speed * delta
	
	return desired_rot

func fly_to_target(to_target, desired_rot, delta):
	var length = to_target.length()
	
	# TODO: implement better braking
	if length > vel.length() * delta:
		thrust(delta)
	elif abs(desired_rot) < PI / 24:
		reverse(delta)
		
func evade_torpedo():
	# change desired_rot if we need to evade
	var torp_pos = torpedo_alert.global_position
	var dist = global_position.distance_to(torp_pos)
	var angle_to_torp = global_position.angle_to_point(torp_pos)
	var angle = 2 * PI - (angle_to_torp + PI)
	
	var t = Position2D.new() 
	t.global_position = Vector2(dist, 0).rotated(angle)
	return t
		
func handle_weapons(target, delta):
	if target.get("health") != null and civ.is_enemy(target):
		shoot(delta)
		
func defend(target):
	var targ_to_operation_dist = target.global_position.distance_to(operational_target.global_position)
	if targ_to_operation_dist >= defend_distance:
		tactical_target = null
		
func attack(target):
	pass

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
			
func handle_attack_from(origin):
	if origin == civ.player:
		civ.relationship_with_player -= 2
	
func _on_AttackRadius_body_entered(body):
	if body != self and civ.is_enemy(body):
		tactical_target = body

func _on_LeaveAloneRadius_body_exited(body):
	if body == tactical_target:
		tactical_target = null
