extends "res://Ship.gd"


# Declare member variables here. Examples:
var tactical_target = null # target to shoot at
var operational_target = null # target of strategic importance
var state = "defend" # relation to operational_target
var civ = null

var tactical_considerations = []

const defend_distance = 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	heat_per_shot = 20
	add_to_group("AI-ships")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = operational_target
	if tactical_target != null:
		target = tactical_target
	
	var to_target = global_position - target.global_position
	
	# rotate towards target
	var desired_angle = fposmod(to_target.angle() + PI, PI * 2)
	var desired_rot = short_angle_dist(rotation, desired_angle)
	
	if abs(desired_rot) > PI / 32:
		rotation += sign(desired_rot) * rot_speed * delta
	
	var length = to_target.length()
	
	# TODO: implement better braking
	if length > vel.length() * delta:
		thrust(delta)
	elif abs(desired_rot) < PI / 24:
		reverse(delta)

	if target.get("health") != null and civ.is_enemy(target):
		shoot(delta)

	var targ_to_operation_dist = target.global_position.distance_to(operational_target.global_position)
	if self.state == "defend" and targ_to_operation_dist >= defend_distance:
		tactical_target = null

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
