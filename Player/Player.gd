extends KinematicBody

onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 20
var mouse_sensitivity = 0.002
var mouse_range = 1.2

var velocity = Vector3.ZERO

var spread = 10
var pellets = 8
var cooling = false

onready var rc = $Pivot/RayCast
onready var flash = $Pivot/Shotgun/Flash
onready var Decal = preload("res://Player/Decal.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pivot/Camera.current = true

func get_input():
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	#print(input_dir)
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	velocity.y += gravity*delta
	if is_on_floor():
		velocity.y = 0
	#print(velocity.y)

	var desired_velocity = get_input()*max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	if velocity != Vector3.ZERO:
		velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("fire") and cooling == false:
		$Pivot/Shotgun/Gunshot.play()
		flash.shoot()
		cooling = true
		$Pivot/Shotgun/Cooldown.start()
		for _i in range(pellets):
			var pitch = rand_range(-spread, spread)
			var yaw = rand_range(-spread, spread)
			var rand_spread = Vector3(pitch, yaw, 0)
			rc.rotation_degrees = rand_spread
			if rc.is_colliding():
				var c = rc.get_collider()
				var decal = Decal.instance()
				rc.get_collider().add_child(decal)
				decal.global_transform.origin = rc.get_collision_point()
				decal.look_at(rc.get_collision_point() + rc.get_collision_normal(), Vector3.UP)
				#print(c)
				if c.is_in_group("Enemy"):
					#c.queue_free()
					c.damage(1)
			rc.force_raycast_update()


func _on_Cooldown_timeout():
	cooling = false
