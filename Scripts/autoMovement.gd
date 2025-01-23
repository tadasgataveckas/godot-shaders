extends CharacterBody3D

#position (ismoving?)
var pos
var oldpos
var moving:bool

var speed = 0.1
var direction = Vector3()
var change_interval = 2.0
var time_since_change = 0.0
var gravity = -9.8
#footprints
var viewport: SubViewport
var texture
var sprites=[]
var points=[]
var point
var timer = 0;
var counter = 0;
var lastindex;
@export var map: MeshInstance3D
#shockwave
var viewport1: SubViewport
var texture1
var shockwavepoint
var shocksprite
#footstep dents
var texture2;
var viewport2;
var pointsfsd = [];
var spritesfsd = [];

func shockwave(sprite,delta):
	sprite.modulate.a = 0.4
	sprite.scale = Vector2(0.02,0.02);
	#Engine.time_scale = 0.05
	while sprite.modulate.a > 0.0:
		sprite.modulate.a -= 0.001 #duration
		sprite.scale += Vector2(0.02,0.02); #rate of travel
		await get_tree().process_frame;

func loopBackFade(currentindex,array):
	for i in range(currentindex-1,-1,-1):
		array[i].modulate.a -= 0.004
	for i in range(array.size()-1,currentindex,-1):
		array[i].modulate.a -= 0.004;
func isMoving():
	pos = global_position
	if pos - oldpos:
		moving = true;
	else:
		moving = false;
	oldpos = pos;
			
func _ready():
	pos = global_position;
	oldpos = global_position;
	
	#footsteps
	viewport = get_parent().get_node("SubViewport");
	viewport.set_clear_mode(SubViewport.CLEAR_MODE_ALWAYS);
	texture = viewport.get_texture();
	var material1 = map.get_active_material(0);
	material1.set_shader_parameter("snowmask", texture);
	

	
	#shockwave
	viewport1 = get_parent().get_node("SubViewport2");
	viewport1.set_clear_mode(SubViewport.CLEAR_MODE_ALWAYS);
	texture1 = viewport1.get_texture();
	var material2 = map.get_active_material(0);
	material2.set_shader_parameter("shockwaveDepthTex",texture1);
	point = viewport1.get_node("Sprite2D");
	point.modulate.a = 0.0;
	
		#footstep dent
	viewport2 = get_parent().get_node("SubViewport3");
	viewport2.set_clear_mode(SubViewport.CLEAR_MODE_ALWAYS);
	texture2 = viewport2.get_texture();
	var material3 = map.get_active_material(0);
	material3.set_shader_parameter("footstepDepthTex",texture2);

	
	
	
	for child in viewport.get_children():
		if child is TextureRect or name.begins_with("s"):
			continue
		sprites.append(child);
	points.resize(sprites.size());
	for child in viewport2.get_children():
		if child is TextureRect or name.begins_with("s"):
			continue
		spritesfsd.append(child);
	pointsfsd.resize(spritesfsd.size());
	

func _process(delta):
	
	
	

	var input = Vector3(
	-(Input.get_action_strength("move_character_right") 
	- Input.get_action_strength("move_character_left")),
	0,
	Input.get_action_strength("move_character_forward") 
	- Input.get_action_strength("move_character_back")
	)
	if is_on_floor():
		velocity = Vector3(input.x*speed, 0, input.z*speed);
	else:
		velocity = Vector3(input.x*speed, gravity*delta*0.5, input.z*speed);
	if(Input.get_action_strength("stop_character",false)):
		velocity = Vector3(0,0,0);
	loopBackFade(counter,sprites);
	loopBackFade(counter,spritesfsd);
	position+=velocity;
	point.position = Vector2(600.0 * (position.x+300)/600.0,
			600.0 * (position.z+300)/600.0)
	timer+=delta;
	if Input.is_action_pressed("ui_numpad1"):
		shockwave(point,delta)
	
	isMoving();
	if(timer>0.5):
		if(moving):
			sprites[counter].modulate.a = 1;
			spritesfsd[counter].modulate.a = 0.4;
			points[counter] = sprites[counter]
			pointsfsd[counter] = spritesfsd[counter]
			points[counter].position = Vector2(1024.0 * (position.x+300)/600.0,
			1024.0 * (position.z+300)/600.0)
			pointsfsd[counter].position = Vector2(600.0 * (position.x+300)/600.0,
			600.0 * (position.z+300)/600.0);
			
		timer = 0;
		counter+=1;
		if counter > sprites.size()-1:
			counter = 0;
	
	move_and_collide(velocity)
	#move_and_slide()
