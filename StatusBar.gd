extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
export var tracked_value = "health"
export var transparent_bg = false
export var fill_color = Color(1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	if transparent_bg:
		$Background.color.a = 0
	$Fill.color = fill_color
	player = get_parent().get_parent() # parent of Canvas Layer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		var w = player.get_as_percent(tracked_value)
		get_node("Fill").set_size(Vector2(w, 10))
		
		
