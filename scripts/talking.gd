class_name Talking
extends ColorRect


signal text_written

@onready var timer: Timer = get_node("Timer")
@onready var dialog: RichTextLabel = get_node("Margin/Dialog")

var text = ""
var text_position = 0

var writing = false


func _ready():
	timer.timeout.connect(write_character)
	self.gui_input.connect(on_dialog_pressed)


func start_writing_text(new_text):
	self.show()
	self.mouse_filter = Control.MOUSE_FILTER_STOP

	dialog.text = ""
	writing = true

	text = new_text
	text_position = 0

	timer.start()

func write_character():
	dialog.text += text[text_position]
	text_position += 1

	if text_position < len(text):
		timer.start()
	else:
		writing = false


func on_dialog_pressed(event: InputEvent):
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		if writing:
			timer.stop()
			text_position = len(text)
			dialog.text = text

			writing = false
		else:
			self.mouse_filter = Control.MOUSE_FILTER_IGNORE
			self.hide()
			
			text_written.emit()
