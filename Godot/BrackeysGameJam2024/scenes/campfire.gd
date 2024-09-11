class_name Campfire extends Node2D

@onready var wood_count = 0
@onready var stone_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func deposit_item(item_type):
	match item_type:
		ResourceNode.RESOURCE_TYPE.WOOD:
			wood_count += 1
		ResourceNode.RESOURCE_TYPE.STONE:
			stone_count += 1

func can_afford_building(building_resource):
	pass
