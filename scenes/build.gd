extends Node2D


var cells : Array
onready var tilemap : TileMap = $TileMap

var shapes = ["I","O","L", "J", "S", "Z", "T"]
var textures = {"I": preload("res://gfx/I.png"), "O":  preload("res://gfx/O.png"), "L": preload("res://gfx/L.png"), "J": preload("res://gfx/J.png"),'S': preload("res://gfx/S.png"), 'Z': preload("res://gfx/Z.png"),'T': preload("res://gfx/T.png")}

onready var block_sprite = get_node("Block")

var current_shape = shapes[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	cells = tilemap.get_used_cells()
	# current_shape = shapes[randi() % len(shapes)]
	current_shape = shapes[2]
	block_sprite.set_texture(textures[current_shape])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	var local_position = tilemap.to_local(event.position)
	var map_position = tilemap.world_to_map(local_position)
	if event is InputEventMouseMotion:
		block_sprite.position = event.position - block_sprite
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#var cell = tilemap.get_cellv(map_position)
			var set_tiles = get_block_tiles(map_position, current_shape)
			
			for tile in set_tiles:
				tilemap.set_cellv(tile, 1)
			# select a new shape after placing the current shape
			var prev_shape = current_shape
			while prev_shape == current_shape:
				current_shape = _get_shape()

			print(current_shape)
			block_sprite.set_texture(textures[current_shape]) 
				
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			tilemap.set_cellv(map_position, 0)
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			var prev_shape = current_shape
			while prev_shape == current_shape:
				current_shape = _get_shape()
			block_sprite.set_texture(textures[current_shape])


func get_block_tiles(map_position, shape):
	var current_x = map_position.x
	var current_y = map_position.y
	match shape:
		"I":
			return [Vector2(current_x, current_y - 2), Vector2(current_x, current_y - 1), Vector2(current_x, current_y), Vector2(current_x, current_y + 1), Vector2(current_x, current_y + 2)]
		"O":
			return [Vector2(current_x, current_y), Vector2(current_x, current_y + 1), Vector2(current_x + 1, current_y), Vector2(current_x + 1, current_y + 1)]
		"L":
			return [Vector2(current_x, current_y), Vector2(current_x, current_y + 1), Vector2(current_x, current_y + 2), Vector2(current_x + 1, current_y + 2)]
func _get_shape():
	return shapes[randi() % len(shapes)]
