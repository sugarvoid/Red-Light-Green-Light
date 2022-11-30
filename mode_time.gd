class_name ModeTime
extends VBoxContainer


onready var min_time: LabeledTextEdit = get_node("MinTime")
onready var max_time: LabeledTextEdit = get_node("MaxTime")


func _ready():
	self.min_time.set_label_text("Min")
	self.max_time.set_label_text("Max")
	
func clear_text_edits() -> void:
	self.min_time.clear_text_edit()
	self.max_time.clear_text_edit()
	

func has_blank_spots() -> bool:
	return self.min_time.is_blank() || self.max_time.is_blank()

func get_min_time() -> int:
	return int(self.min_time.get_text_edit_vaule())
	
func get_max_time() -> int:
	return int(self.max_time.get_text_edit_vaule())

