class_name LabeledTextEdit
extends HBoxContainer


onready var label: Label = get_node("Label")
onready var text_edit: TextEdit = get_node("TextEdit")


func set_label_text(text: String) -> void:
	self.label.text = text

func is_blank() -> bool:
	return text_edit.text.empty()

func get_text_edit_vaule() -> String:
	return text_edit.text
