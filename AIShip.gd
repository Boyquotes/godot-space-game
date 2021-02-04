extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const acc = 300
const dec = 150
const max_speed = 400
const rot_speed = PI

var target = null

var vel = Vector2(0 ,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("AI-ships")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null:
		return
	
	var to_target = global_position - target.global_position
	
	# rotate towards target
	var desired_angle = to_target.angle() + PI
	rotation = desired_angle
	
	# control speed
	var length = to_target.length()
	if length > 75:
		thrust(delta)
	
	move_and_collide(vel * delta)
	
		
func thrust(delta):
	vel += Vector2(acc * delta, 0).rotated(rotation)
	
func reverse(delta):
	vel -= Vector2(dec * delta, 0).rotated(rotation)

func _on_AttackRadius_body_entered(body):
	target = body

func _on_LeaveAloneRadius_body_exited(body):
	if body == target:
		target = null
