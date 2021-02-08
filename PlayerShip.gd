extends "res://Ship.gd"

var landing_target = null

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
		
	if Input.is_action_just_pressed("land"):
		land()
		
	update_heat_bar_color()
	
func land():
	if landing_target != null:
		if not landing_target.get_parent().civ.is_enemy(self):
			self.health = self.max_health
		
func update_heat_bar_color():
	if venting:
		$CanvasLayer/HeatBar/Fill.color = Color(1.0, 0, 0)
	else:
		$CanvasLayer/HeatBar/Fill.color = Color(1.0, 1.0, 1.0)		


func _on_LandingGear_body_entered(body):
	if body.is_in_group("structures"):
		landing_target = body

func _on_LandingGear_body_exited(body):
	if body.is_in_group("structures"):
		landing_target = null
