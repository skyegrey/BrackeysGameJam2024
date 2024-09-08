class_name VillagerManager extends Node2D

# Prefabs -- haha unity
const VILLAGER = preload("res://scenes/villager.tscn")

# Properties
@export var starting_villagers_count := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_in_starting_villiagers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _spawn_in_starting_villiagers():
	for index in range(starting_villagers_count):
		_spawn_in_villager()

func _spawn_in_villager():
	var new_villager = VILLAGER.instantiate()
	new_villager.position = Vector2(randf(), randf())
	add_child(new_villager)

func box_select(area_selected: Rect2):
	for villager in get_children():
		if area_selected.has_point(villager.position):
			villager.select()
