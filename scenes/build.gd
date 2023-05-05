extends Node2D


var cells : Array
onready var tilemap : TileMap = $TileMap

var orientation = 0
onready var block_sprite = get_node("Block")

var shapes = {
	"I": {
		"blocks": [[0, 0], [0, 1], [0, -1], [0, -2]],
		"texture": preload("res://gfx/I.png")
	},
	"O": {
		"blocks": [[0, 0], [1, 0], [0, 1], [1, 1]],
		"texture": preload("res://gfx/O.png")
	},
	"T": {
		"blocks": [[0, 0], [1, 0], [-1, 0], [0, 1]],
		"texture": preload("res://gfx/T.png")
	},
	"S": {
		"blocks": [[0, 0], [1, 0], [-1, 1], [0, 1]],
		"texture": preload("res://gfx/S.png")
	},
	"Z": {
		"blocks": [[0, 0], [1, 0], [1, 1], [2, 1]],
		"texture": preload("res://gfx/Z.png")
	},
	"J": {
		"blocks": [[0, 0], [1, 0], [2, 0], [2, 1]],
		"texture": preload("res://gfx/J.png")
	},
	"L": {
		"blocks": [[0, 1], [1, 1], [2, 1], [2, 0]],
		"texture": preload("res://gfx/L.png")
	}
}

var current_shape

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	cells = tilemap.get_used_cells()
	var keys = shapes.keys()
	current_shape = keys[randi() % keys.size()]
	block_sprite.set_texture(shapes[current_shape].texture)
	block_sprite.rotation_degrees = orientation * 90

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		block_sprite.position = event.position

		
	if event is InputEventMouseButton:
		var local_position = tilemap.to_local(event.position)
		var map_position = tilemap.world_to_map(local_position)

		if event.button_index == BUTTON_LEFT and event.pressed:
			var shape_blocks = shapes[current_shape].blocks
			for block in shape_blocks:
				var rotated_block = rotate_block(block, orientation)
				
				var pos = (map_position + rotated_block).floor()
				tilemap.set_cellv(pos, 1, true)
			# select a new shape after placing the current shape
			var prev_shape = current_shape
			while prev_shape == current_shape:
				current_shape = _get_shape()
				orientation = _get_orientation()

			block_sprite.rotation_degrees = orientation * 90
			block_sprite.set_texture(shapes[current_shape].texture)
				
		if event.button_index == BUTTON_RIGHT and event.pressed:
			tilemap.set_cellv(map_position, 0)
			
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			var prev_shape = current_shape
			while prev_shape == current_shape:
				current_shape = _get_shape()

		if event.scancode == KEY_E:
			orientation += 1
			if orientation > 3:
				orientation = 0

		if event.scancode == KEY_W:
			orientation -= 1
			if orientation < 0:
				orientation = 4
			
		block_sprite.rotation_degrees = orientation * 90
		block_sprite.set_texture(shapes[current_shape].texture)
			


func rotate_block(block, orientation):
	var x = block[0]
	var y = block[1]
	if orientation == 0:
		return Vector2(x, y)
	elif orientation == 1:
		return Vector2(-y, x)
	elif orientation == 2:
		return Vector2(-x, -y)
	elif orientation == 3:
		return Vector2(y, -x)

func _get_shape():
	var keys = shapes.keys()
	var random_shape = keys[randi() % keys.size()]

	return random_shape

func _get_orientation():
	return randi() % 4
