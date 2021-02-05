extends Node2D


# Declare member variables here. Examples:
var civs = []
var bars = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bar_w = $Baseline.get_size().x / civs.size()	
	for civ in bars:
		var bar = bars[civ]
		var h = abs(civ.relationship_with_player)
		var x = bar.get_position().x
		var y = $Baseline.get_position().y
		if civ.relationship_with_player > 0:
			y -= h
		bar.set_position(Vector2(x, y))		
		bar.set_size(Vector2(bar_w, h))
	
func create_bars():
	var bar_w = $Baseline.get_size().x / civs.size()
	for i in range(civs.size()):
		var civ = civs[i]
		var bar = ColorRect.new()
		bar.set_position(Vector2(bar_w * i, $Baseline.get_position().y))
		bar.set_size(Vector2(bar_w, 0))
		bar.color = civ.color
		bars[civ] = bar
		add_child(bar)

func add_civ(civ):
	civs.append(civ)
