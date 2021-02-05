extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
export var tracked_value = "health"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent() # parent of Canvas Layer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		var w = player.get_as_percent(tracked_value)
		get_node("Fill").set_size(Vector2(w, 10))
