class_name Villager extends Node2D

# Children references
@onready var hitbox = $Hitbox
@onready var animated_sprite_2d = $AnimatedSprite2D

# Properties
@export var movement_speed := 100

# State variables
@onready var movement_vector = Vector2.ZERO
@onready var overlapping_villagers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.area_entered.connect(_is_overlapping_other_villager)
	hitbox.area_exited.connect(_villager_hitbox_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if overlapping_villagers:
		_calculate_movement_vector_away_from_villager()
	else:
		movement_vector = Vector2.ZERO
	_process_movement(delta)

func _is_overlapping_other_villager(villager_area: Area2D):
	var overlapping_villager = villager_area.get_parent()
	overlapping_villagers.append(overlapping_villager)

func _villager_hitbox_exited(villager_area: Area2D):
	overlapping_villagers.erase(villager_area.get_parent())

func _calculate_movement_vector_away_from_villager():
	var added_vectors = Vector2.ZERO
	for villager in overlapping_villagers:
		added_vectors += position - villager.position
	movement_vector = added_vectors.normalized()

func _process_movement(delta):
	if movement_vector != Vector2.ZERO:
		position += movement_vector * delta * movement_speed

func select():
	animated_sprite_2d.use_parent_material = false
