class_name ResourceNode extends Node2D

# Enums
enum RESOURCE_TYPE {
	NONE,
	WOOD,
	STONE
}

# Child references
@onready var resource_hitbox = $ResourceHitbox

# Abstract properties
var resource_type

# Signals
signal mouse_entered
signal mouse_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	resource_hitbox.mouse_entered.connect(_on_mouse_hover)
	resource_hitbox.mouse_exited.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_hover():
	mouse_entered.emit(self)

func _on_mouse_exited():
	mouse_exited.emit()

func set_assigned_villagers(villagers):
	for villager in villagers:
		villager.assign_job(Villager.JOBS.COLLECTING_RESOURCES, self)
