extends Camera3D



@export var sensitivity: float = 0.1  
@export var speed: float = 5.0 
var rotation_angles: Vector3 = Vector3.ZERO  

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_angles.x -= event.relative.y * sensitivity
		rotation_angles.y -= event.relative.x * sensitivity

		rotation_angles.x = clamp(rotation_angles.x, -90, 90)
		rotation_degrees = Vector3(rotation_angles.x,  rotation_angles.y, 0.0)

func _process(delta) -> void:
		var input = Vector3(
		-(Input.get_action_strength("move_right") - Input.get_action_strength("move_left")),
		0,
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		)
		#get_parent().position += self.position;
		var direction = -(transform.basis.x * input.x + transform.basis.z * input.z).normalized()
		#global_transform.origin += direction * speed * delta
		get_parent().global_position +=direction * speed *delta
	
