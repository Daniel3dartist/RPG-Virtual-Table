extends TextureRect

signal char_image_path(path)

var mouse_in: bool

func _ready():
	get_tree().connect('files_dropped', self, '_on_files_dropped')

func _on_TextureRect_mouse_entered():
	mouse_in = true

func _on_TextureRect_mouse_exited():
	mouse_in = false

func _on_files_dropped(files, screen):
	if mouse_in == true:
		emit_signal("char_image_path", files[0])
