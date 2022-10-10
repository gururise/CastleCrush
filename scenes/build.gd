extends Node2D


var cells : Array
onready var tilemap : TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	cells = tilemap.get_used_cells()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		var local_position = tilemap.to_local(event.position)
		var map_position = tilemap.world_to_map(local_position)
		#var cell = tilemap.get_cellv(map_position)
		if event.button_index == BUTTON_LEFT:
			tilemap.set_cellv(map_position, 1)
		else:
			tilemap.set_cellv(map_position, 0)
