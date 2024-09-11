class_name Villager extends Node2D

enum JOBS {
	NOT_ASSIGNED,
	COLLECTING_RESOURCES,
	BUILD_BUILDING
}

# Children references
@onready var hitbox = $Hitbox
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var resource_collection_timer = $ResourceCollectionTimer
@onready var held_item_sprite = $HeldItemSprite

# Properties
@export var movement_speed := 100
@export var target_closeness_threshold := 2
var item_type_to_atlas_region = {
	ResourceNode.RESOURCE_TYPE.WOOD: Rect2(16, 16, 16, 16),
	ResourceNode.RESOURCE_TYPE.STONE: Rect2(48, 32, 16, 16)
}

# State variables
@onready var movement_vector = Vector2.ZERO
@onready var overlapping_villagers = []
@onready var target_position = Vector2.ZERO
@onready var job = JOBS.NOT_ASSIGNED
@onready var target_node
@onready var held_item
@onready var in_resource_range: bool = false
@onready var is_touching_campfire: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.area_entered.connect(_on_area_entered)
	hitbox.area_exited.connect(_on_area_exited)
	resource_collection_timer.timeout.connect(_on_resource_collected)

func _process(delta):
	if job == JOBS.COLLECTING_RESOURCES:
		_handle_resouce_collecting()
	if job == JOBS.NOT_ASSIGNED:
		if target_position:
			_move_to_target()
		elif overlapping_villagers:
			_calculate_movement_vector_away_from_villager()
		else:
			movement_vector = Vector2.ZERO
	_process_movement(delta)

func _on_area_entered(area: Area2D):
	var parent_node = area.get_parent()
	if parent_node is Villager:
			_is_overlapping_other_villager(parent_node)
	elif parent_node is ResourceNode:
			_is_overlapping_resource(parent_node)
	elif parent_node is Campfire:
			_campfire_entered(parent_node)

func _on_area_exited(area: Area2D):
	var parent_node = area.get_parent()
	if parent_node is Villager:
		_villager_hitbox_exited(parent_node)
	elif parent_node is ResourceNode:
		_resource_exited()
	elif parent_node is Campfire:
		_campfire_exited()

func _is_overlapping_other_villager(overlapping_villager):
	overlapping_villagers.append(overlapping_villager)

func _is_overlapping_resource(resource_node):
	if resource_node == target_node:
		_on_arrived_at_resource_node()

func _villager_hitbox_exited(villager):
	overlapping_villagers.erase(villager)

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

func set_target_position(_position):
	target_position = _position

func _move_to_target():
	if position.distance_to(target_position) <= target_closeness_threshold:
		target_position = Vector2.ZERO
	movement_vector = (target_position - position).normalized()

func assign_job(job_type, selectable_node):
	job = job_type
	target_node = selectable_node

func unassign_job():
	job = JOBS.NOT_ASSIGNED
	target_node = null

func _set_movement_twoards_resource():
	movement_vector = (target_node.position - position).normalized()

func _handle_resouce_collecting():
	# If not at the resource & not holding anything, move to the resource
	if not held_item && not in_resource_range:
		_set_movement_twoards_resource()
	
	# If holding the resource, drop off at campfire
	if held_item:
		_set_movement_twoards_camp()

func _play_resource_gathering_animation():
	pass

func _set_movement_twoards_camp():
	movement_vector = (-position).normalized()

func _on_resource_collected():
	held_item = target_node.resource_type
	held_item_sprite.texture.region = item_type_to_atlas_region[held_item]
	held_item_sprite.visible = true

func _on_arrived_at_resource_node():
	movement_vector = Vector2.ZERO
	in_resource_range = true
	_play_resource_gathering_animation()
	resource_collection_timer.start()

func _campfire_entered(campfire):
	if held_item:
		campfire.deposit_item(held_item)
		held_item = ResourceNode.RESOURCE_TYPE.NONE
		held_item_sprite.visible = false

func _campfire_exited():
	pass

func _resource_exited():
	in_resource_range = false
