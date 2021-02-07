extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const zoom_speed = 1.0

var target_zoom = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	var pos = get_parent().global_position
	var closest_dist = INF
	for body in get_tree().get_nodes_in_group("celestial-bodies"):
		var d = pos.distance_to(body.global_position)
		if d < closest_dist:
			closest_dist = d
	
	var h = get_viewport_rect().size.y
	if closest_dist > h * 0.6:
		target_zoom = Vector2(2.25, 2.25)
	elif closest_dist < h * 0.5:
		target_zoom = Vector2(1.0, 1.0)
		
	zoom = zoom.linear_interpolate(target_zoom, zoom_speed * dt)
