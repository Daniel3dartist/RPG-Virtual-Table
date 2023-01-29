extends TextureRect

signal char_image_path(path)

func _ready():
	get_tree().connect('files_dropped', self, '_on_files_dropped')

func _on_files_dropped(files, screen):
	var vx = self.get_global_position().x + self.rect_size.x
	var vy = self.get_global_position().y + self.rect_size.y
	if get_global_mouse_position().x <= vx and get_global_mouse_position().x >= vx - self.rect_size.x and get_global_mouse_position().y <= vy and get_global_mouse_position().x >= vy - self.rect_size.y:
		emit_signal("char_image_path", files[0])
	


