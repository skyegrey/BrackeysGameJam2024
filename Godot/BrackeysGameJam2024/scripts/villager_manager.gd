class_name VillagerManager extends Node2D
@onready var main = $".."

# Prefabs -- haha unity
const VILLAGER = preload("res://scenes/villager.tscn")

# Properties
@export var starting_villagers_count := 3

# State variables
@onready var selected_villagers = []
@onready var villager_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_in_starting_villiagers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _spawn_in_starting_villiagers():
	for index in range(starting_villagers_count):
		spawn_new_villager()

func spawn_new_villager(villager_hut: VillagerHut = null):
	var new_villager = VILLAGER.instantiate()
	if villager_hut:
		new_villager.position = villager_hut.position
		
	new_villager.position += Vector2(randf(), randf())
	villager_count += 1
	add_child(new_villager)

func box_select(area_selected: Rect2):
	for villager in get_children():
		if area_selected.has_point(villager.position):
			selected_villagers.append(villager)
			villager.select()

func move_selected_units(event_position: Vector2):
	for villager in selected_villagers:
		villager.set_target_position(event_position)

func deselect_units():
	selected_villagers = []

func has_selected_units():
	return not selected_villagers.is_empty()

func get_selected_villagers():
	return selected_villagers

func unassign_jobs():
	for villager in selected_villagers:
		villager.unassign_job()
