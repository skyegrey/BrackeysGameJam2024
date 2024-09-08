class_name Main extends Node2D

@onready var mouse_input_handler = %MouseInputHandler
@onready var villager_manager = %VillagerManager

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_input_handler.mouse_drag_finished.connect(_on_box_select)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_box_select(area_selected: Rect2):
	# var building_select = building_manager.select??
	villager_manager.box_select(area_selected)
