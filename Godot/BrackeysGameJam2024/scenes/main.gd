class_name Main extends Node2D

@onready var mouse_input_handler = %MouseInputHandler
@onready var villager_manager = %VillagerManager
@onready var hovered_resource
@onready var wood_resource = $WoodResource
@onready var stone_resource = $StoneResource
@onready var ui = %UI
@onready var campfire = %Campfire
@onready var building_type_to_resource = {
	BuildingContainer.BUILDING_TYPE.TENT: preload("res://resources/instances/tent.tres")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_to_mouse_handler_signals()
	_connect_to_resource_signals()
	_connect_to_ui_signals()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_ui()

func _on_box_select(area_selected: Rect2):
	# var building_select = building_manager.select??
	villager_manager.box_select(area_selected)

func _on_mouse_right_click(event_position):
	if villager_manager.has_selected_units():
		if hovered_resource:
			hovered_resource.set_assigned_villagers(villager_manager.get_selected_villagers())
		else:
			villager_manager.unassign_jobs()
			villager_manager.move_selected_units(event_position)

func _on_box_start():
	villager_manager.deselect_units()

func _connect_to_mouse_handler_signals():
	mouse_input_handler.mouse_drag_started.connect(_on_box_start)
	mouse_input_handler.mouse_drag_finished.connect(_on_box_select)
	mouse_input_handler.mouse_right_clicked.connect(_on_mouse_right_click)

func _connect_to_resource_signals():
	wood_resource.mouse_entered.connect(_set_hovered_resource)
	wood_resource.mouse_exited.connect(_deselect_hovered_resource)
	stone_resource.mouse_entered.connect(_set_hovered_resource)
	stone_resource.mouse_exited.connect(_deselect_hovered_resource)

func _set_hovered_resource(resource):
	hovered_resource = resource

func _deselect_hovered_resource():
	hovered_resource = false

func _update_ui():
	ui.update_villager_count(villager_manager.villager_count)
	ui.update_wood_count(campfire.wood_count)
	ui.update_stone_count(campfire.stone_count)

func _connect_to_ui_signals():
	ui.on_building_clicked.connect(_on_building_clicked)

func _on_building_clicked(building_type):
	var building_resource = building_type_to_resource[building_type]
	if campfire.can_afford_building(building_resource):
		campfire.pay_for_building(building_resource)
		ui.set_current_build(building_resource)
		ui.on_building_cancelled.connect(_on_building_canceled.bind(building_resource), CONNECT_ONE_SHOT)

func _on_building_canceled(building_resource):
	campfire.refund_building(building_resource)
