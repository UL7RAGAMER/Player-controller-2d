extends CharacterBody2D
class_name Movement
@onready var dash_timer: Timer = $Dash_timer
@onready var coyote_timer: Timer = $Coyote_timer
@onready var debug_test: Label = $"Debug test"
@onready var wall_slide_timer: Timer = $Wall_slide_timer





# Change this to work with any AnimatedSprite2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var collision_shape_2d: CollisionShape2D
@export var ceiling_collider: RayCast2D
@export var animation_player: AnimationPlayer


@export_category("Movement settings")
@export var speed_increment = 20

@export var speed_limit = 145
@export var fall_speed_limit = 50
@export var jump_velocity = -350

@export var gravity_multipler = 1
@export var speed_multipler = 1

@export_category("Dash_setting")
@export var dash_velocity = 300
@export_category("Movement abilities")
@export var dash_enabled = false
@export var wall_slide_enabled = false
@export var max_jumps = 1

@export_category("Debugger tools")
@export_range(0.1,5,0.1,'or_greater') var time_scale : float = 1
var has_jumped = false
var is_dashing = false
var is_running = false
var is_sliding = false
var is_idle = true
var is_sliding_left = false
var is_sliding_right = false
var can_run = true
var can_dash = true
var can_jump = true
var can_slide = true
var can_idle = true
var was_on_floor = true
var collision_shape_offset = 10
var reverse_to_right = false
var reverse_to_left = true
var jumps_left : int

var direction_wall = 0
func _ready() -> void:
	jumps_left = max_jumps
	#atk1.end() # Do the same for any futere attacks
	#atk2.end()
	print_tree()
	pass



	
func _physics_process(delta: float) -> void:
	debug_test.text = str(jumps_left)
	Engine.time_scale = time_scale
	if animated_sprite_2d.flip_h:
		weapon.scale =  Vector2(1,-1)
		
	else :
		weapon.scale =  Vector2(-1,-1)
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multipler
	else:
		gravity_multipler = 1
		speed_multipler = 1
		has_jumped = false
		can_jump = true
		can_run  = true
		is_sliding = false
		fall_speed_limit = 500
		ceiling_collider.enabled = false
		jumps_left = max_jumps
	movement()
	jump()
	if dash_enabled:
		dash()
	if wall_slide_enabled:
		wall_slide()
	was_on_floor = is_on_floor() # This is for Coyote time
	move_and_slide()
func dash():

	var direction = 0
	if animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1

	if Input.is_action_just_pressed("Dash") and !is_dashing and can_dash:
		animated_sprite_2d.play('dash')
		dash_timer.start()
		velocity.y = 0.01
		is_running = false
		is_dashing = true
		can_dash = false
		is_sliding = false
		
		print('Dash')
		
		gravity_multipler = 0
		velocity.x += dash_velocity * direction
			
	elif is_dashing and velocity.x !=0:
		await get_tree().create_timer(0.1).timeout
		velocity.x = move_toward(velocity.x, 0, speed_increment)
	if abs(velocity.x) < speed_limit and is_dashing:
		gravity_multipler = 1
		is_dashing = false

func wall_slide():
	
	if is_on_ceiling():
		return
	if is_on_wall_only() and can_slide:
		ceiling_collider.enabled = true
		can_dash = false
		
		var right_pressed = Input.is_action_pressed("Right")
		var left_pressed = Input.is_action_pressed('Left')
		
		if (right_pressed or left_pressed ):
			
			if (right_pressed and left_pressed): # This weird condition is to prevent a bug when sliding on the wall and pressing both left and right
				if direction_wall == 1:
					animated_sprite_2d.flip_h = false
					collision_shape_2d.position.x = collision_shape_offset/2.7
				elif  direction_wall == -1:
					animated_sprite_2d.flip_h = true
					collision_shape_2d.position.x = collision_shape_offset/1.8
				pass
				
			elif left_pressed :
				direction_wall = 1
				animated_sprite_2d.flip_h = false
				collision_shape_2d.position.x = collision_shape_offset/2.7
			elif right_pressed :
				direction_wall = -1
				animated_sprite_2d.flip_h = true
				collision_shape_2d.position.x = collision_shape_offset/1.8
			can_jump = false
			can_run = false
			is_sliding = true
			can_dash = false
			animated_sprite_2d.play('wall_slide')
			velocity.x = -direction_wall
			fall_speed_limit = 200
		if velocity.y > 0:
			gravity_multipler = 0.3
		if Input.is_action_just_pressed("Jump") and is_sliding and velocity.y> 0 and !(ceiling_collider.get_collider() is TileMapLayer):
			print('asd5 ')
			can_jump = false
			can_slide = false
			wall_slide_timer.start()
			velocity.x = -jump_velocity * direction_wall*9
			gravity_multipler = 1
			velocity.y = jump_velocity/1.2
			can_run = true
			can_dash = true
		
	elif is_sliding:
		gravity_multipler = 1
		can_run = true
		is_sliding = false
		can_dash = true
		if velocity.y >0 or velocity.x !=0:
			fall_speed_limit = 500
			animated_sprite_2d.play('fall')
		can_jump = false
	
func jump():
	
	
	if !has_jumped and was_on_floor:
		coyote_timer.start()
		
	velocity.y = clamp(velocity.y,jump_velocity,fall_speed_limit)
	if Input.is_action_pressed("Right")and !is_dashing and !is_on_floor() :
		reverse_to_left = true
		reverse_to_right = false

	if Input.is_action_pressed("Left")and !is_dashing and !is_on_floor():
		reverse_to_left = false
		reverse_to_right = true
	if Input.is_action_just_pressed("Jump") and can_jump:
		is_idle = false
		if jumps_left != 0:
			jumps_left -= 1
			print('asd2')
		else :
			print('asd1')
			can_jump = false
		speed_multipler = 1
		animated_sprite_2d.play('jump')
		velocity.y = jump_velocity
		
		has_jumped = true
	if Input.is_action_just_released("Jump") and not(has_jumped and velocity.y > 0) and has_jumped : #The extra has_jumped is for fixing a jump glitch whill falling without jumping
		velocity.y/=5
	if velocity.y > 0 and !is_dashing and !is_sliding:
		animated_sprite_2d.play('fall')
		gravity_multipler=1.3
		if jumps_left == 0:
			print('asd')
			can_jump = false
		
func movement():
	if is_on_floor(): # This is for preventing a weird jitter when running and jumping
		floor_stop_on_slope = true
	else:
		floor_stop_on_slope = false
	if velocity.x!=0:
		animated_sprite_2d.speed_scale = abs(velocity.x) * 1/80
	
	if Input.is_action_pressed("Right")and !is_dashing and can_run and !is_attacking :
		can_idle = true
		is_running = true
		collision_shape_2d.position.x = 0
		reverse_to_left = true
		if is_on_floor():
			if reverse_to_right == true:
				
				animated_sprite_2d.play('turn_around')
			elif !is_attacking:
				animated_sprite_2d.play("run")
			
		velocity.x = speed_limit * speed_multipler
		animated_sprite_2d.flip_h = false
	elif Input.is_action_pressed("Left") and !is_dashing and can_run and !is_attacking :
		can_idle = true
	
		is_running = true
		collision_shape_2d.position.x = collision_shape_offset
		reverse_to_right = true
		if is_on_floor():
			if reverse_to_left == true and !has_jumped:
				
				animated_sprite_2d.play('turn_around')
			elif !is_attacking:
				animated_sprite_2d.play("run")
			
		velocity.x = -speed_limit * speed_multipler
		animated_sprite_2d.flip_h = true
	elif !is_dashing and can_idle :
		is_idle = true
		is_running = false
		velocity.x = move_toward(velocity.x, 0, 5)
		if velocity == Vector2.ZERO:
			animated_sprite_2d.speed_scale = 1
			animated_sprite_2d.play('idle')

var is_attacking = false
var can_atk = true
@onready var weapon: Node2D = $Weapon
@onready var atk1: player_attack_data = $Weapon/Attack1
@onready var atk2: player_attack_data = $Weapon/Attack2

var atk = true
func attack():

	if !is_running and can_atk:
		velocity.x = 0
		can_atk = false
		is_attacking = true
		is_running = false
		can_idle = false
		can_dash = false
		if atk:
			animation_player.play('Attack')
			atk1.visible = true
			atk2.visible = false
		elif !atk:
			animation_player.play('Attack2')
			atk1.visible = false
			atk2.visible = true

func _on_dash_timer_timeout() -> void:
	can_dash = true
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if "turn_around" in animated_sprite_2d.animation:
		if reverse_to_left:
			reverse_to_left = false
		if reverse_to_right:
			reverse_to_right = false
	if 'attack' in animated_sprite_2d.animation:
		atk= !atk
		can_idle = true
		can_run = true
		can_dash = true
		is_attacking = false
		await get_tree().create_timer(0.01).timeout
		can_atk = true
	pass # Replace with function body.

func _on_coyote_timer_timeout() -> void:
	if jumps_left == 0:
		can_jump = false
	pass # Replace with function body.


func _on_wall_slide_timer_timeout() -> void:
	can_slide = true
	pass # Replace with function body.
