extends "res://Ship.gd"


# Declare member variables here. Examples:
var target = null
var civ = null

# Called when the node enters the scene tree for the first time.
func _ready():
	heat_per_shot = 20
	add_to_group("AI-ships")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var to_target = global_position - target.global_position
		
		# rotate towards target
		var desired_angle = to_target.angle() + PI
		rotation = desired_angle
		
		# accelerate
		var length = to_target.length()
		if length > 75:
			thrust(delta)

		if target.get("health") != null and civ.is_enemy(target):
			shoot(delta)
			
func handle_attack_from(origin):
	if origin == civ.player:
		civ.relationship_with_player -= 2
	
func _on_AttackRadius_body_entered(body):
	if body != self and civ.is_enemy(body):
		target = body

func _on_LeaveAloneRadius_body_exited(body):
	if body == target:
		target = null
