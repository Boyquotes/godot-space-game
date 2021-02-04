extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
const lifelength = 1
var age = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	age += delta
	var collision = move_and_collide(self.vel * delta)
	if collision != null:
		if collision.collider.get("health") != null:
			collision.collider.take_hit(10)
		queue_free()
	
	if age >= lifelength:
		queue_free()
