extends Node2D

@onready var villager_hut = $VillagerHut
@onready var villager_manager = %VillagerManager


# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_to_villager_hut_signals(villager_hut)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _connect_to_villager_hut_signals(villager_hut: VillagerHut):
	villager_hut.spawn_new_villager.connect(_spawn_new_villager)

func _spawn_new_villager(villager_hut):
	villager_manager.spawn_new_villager(villager_hut)
