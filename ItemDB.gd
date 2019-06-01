extends Node2D

const ICON_PATH = "res://assets/"

const ITEMS = {
	"sword": {
		"asset": ICON_PATH + "sword.png",
		"slot": "MAIN_HAND"
	},
	"breastplate": {
		"asset": ICON_PATH + "breastplate.png",
		"slot": "CHEST"
	},
	"potato": {
		"asset": ICON_PATH + "potato.png",
		"slot": "NONE"
	},
	"error": {
		"asset": ICON_PATH + "error.png",
		"slot": "NONE"
	},
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
