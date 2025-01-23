extends ColorRect

var viewport : Viewport
var captured_texture : ViewportTexture
var image
var timer = 0;
@export var timerrange: float;

func _ready():
	captured_texture = get_viewport().get_texture()
	
func _process(delta: float) -> void:
	timer+=delta
	if(timer>timerrange):
		timer=0.0;
		image = captured_texture.get_image();
		var texture = ImageTexture.create_from_image(image);
		material.set_shader_parameter("captured_texture",texture);
