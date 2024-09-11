class_name UI extends Control

@onready var villager_amount_label = %VillagerAmountLabel
@onready var wood_amount_label = %WoodAmountLabel
@onready var stone_amount_label = %StoneAmountLabel
@onready var building_container = $BuildingContainer

# State variables
var is_building_container_hovered = false

# Signals
signal on_building_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	building_container.mouse_entered.connect(_on_building_container_hovered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_villager_count(villager_count):
	villager_amount_label.text = str(villager_count)

func update_wood_count(wood_count):
	wood_amount_label.text = str(wood_count)

func update_stone_count(stone_count):
	stone_amount_label.text = str(stone_count)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if is_building_container_hovered:
			on_building_clicked.emit(building_container.hovered_building)

func _on_building_container_hovered():
	is_building_container_hovered = true
