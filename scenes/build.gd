extends Node2D


var cells : Array
onready var tilemap : TileMap = $TileMap

var shapes = ['I','SQUARE','L1', 'L2', 'S1', 'S2', 'T']
var textures = {'I': preload("res://gfx/I.png"), 'SQUARE':  preload("res://gfx/SQUARE.png"), 'L1': preload("res://gfx/L1.png"), 'L2': preload("res://gfx/L2.png"),'S1': preload("res://gfx/S1.png"), 'S2': preload("res://gfx/S2.png"),'T': preload("res://gfx/T.png")}
var shapes_full = []

onready var block_sprite = get_node("Block")

var current_shape = shapes[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	cells = tilemap.get_used_cells()
	shapes_full = shapes.duplicate()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		var local_position = tilemap.to_local(event.position)
		var map_position = tilemap.world_to_map(local_position)
		#var cell = tilemap.get_cellv(map_position)
		if event.button_index == BUTTON_LEFT:
			match current_shape:
				'I':
					var current_x = map_position.x
					var current_y = map_position.y
					var I_tiles = [Vector2(current_x, current_y - 2), Vector2(current_x, current_y - 1), Vector2(current_x, current_y), Vector2(current_x, current_y + 1), Vector2(current_x, current_y + 2)]
					for tile in I_tiles:
						tilemap.set_cellv(tile, 1)
					
		else:
			tilemap.set_cellv(map_position, 0)
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			# change texture
			# map position 
			# map_position.x and map_position.y depending on shape
			# if else on shape type is what you set_cell
			current_shape = getShape()
			block_sprite.set_texture(textures[current_shape])
			pass
	if event is InputEventMouseMotion:
		block_sprite.position = event.position


func getShape():
	if shapes.empty():
		shapes = shapes_full.duplicate()
		shapes.shuffle()
	var random_shape = shapes.pop_front()
	
	return random_shape

