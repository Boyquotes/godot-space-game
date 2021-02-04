extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var extent = 450

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = get_parent().global_position
	var closest_dist = INF
	var node = null
	for body in get_tree().get_nodes_in_group("celestial-bodies"):
		var d = pos.distance_to(body.global_position)
		if d < closest_dist:
			closest_dist = d
			node = body

	if node.global_position.distance_to(pos) < extent:
		self.visible = false
	else:
		global_position = (node.global_position - pos).normalized() * extent + pos
		visible = true
