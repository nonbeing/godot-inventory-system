extends Control

const item_base = preload("res://ItemBase.tscn")

onready var inv_base = $InventoryBase
onready var grid_bkpk = $GridBackPack
onready var eq_slots = $EquipmentSlots

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos = Vector2()

func _ready():
	pickup_item("sword")
	pickup_item("breastplate")
	pickup_item("potato")
	pickup_item("breastplate")
	pickup_item("potato")
	pickup_item("potato")
	pickup_item("ZXVCLJDSF")


func _process(delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab"):
		grab(cursor_pos)
	if Input.is_action_just_released("inv_grab"):
		release(cursor_pos)
	if item_held != null:
		item_held.rect_global_position = cursor_pos + item_offset

func grab(cursor_pos):
	var c = get_container_under_cursor(cursor_pos)
	if c and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos) 
		if item_held:
			last_container = c
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_pos
			move_child(item_held, get_child_count())
	

func get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, inv_base]
	
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null

func release(cursor_pos):
	if not item_held:
		return
	
	var c = get_container_under_cursor(cursor_pos)
	if not c:
		drop_item()
	elif c.has_method("insert_item"):
		if c.insert_item(item_held):
			item_held = null
		else:
			return_item_to_last_slot()
	else:
		return_item_to_last_slot()
		
	
	
func drop_item():
	item_held.queue_free()
	item_held = null
	
func return_item_to_last_slot():
	item_held.rect_global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null
	
	
func pickup_item(item_id):
	var item = item_base.instance()
	item.set_meta("id", item_id)
	item.texture = load(ItemDB.get_item(item_id)["asset"])
	add_child(item)
	if !grid_bkpk.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	return true
	
	
	
	
	
	
	
	
	