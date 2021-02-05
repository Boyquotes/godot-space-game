extends "res://Ship.gd"


# Declare member variables here. Examples:
var target = null

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
	
		# control speed
		var length = to_target.length()
		if length > 75:
			thrust(delta)

		if target.get("health") != null:
			shoot(delta)
	
func _on_AttackRadius_body_entered(body):
	if body != self:
		target = body

func _on_LeaveAloneRadius_body_exited(body):
	if body == target:
		target = null
