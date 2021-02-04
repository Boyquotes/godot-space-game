extends "res://Ship.gd"

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
		shoot(delta)

