extends CollisionShape3D

var heightmap: Texture = ResourceLoader.load("res://Resource/heightmap4.exr");
var heightmap_image: Image
var height_min:float = 0.0;
var height_max:float = 50.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heightmap_image = heightmap.get_image();
	heightmap_image.convert(Image.FORMAT_RF);
	shape.update_map_data_from_image(heightmap_image,height_min,height_max);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
