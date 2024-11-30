extends CharacterBody2D

@onready var dash_timer: Timer = $Dash_timer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $Jump_timer
@onready var debug_test: Label = $"Debug test"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



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


var has_jumped = false
var is_dashing = false
var is_running = false
var can_dash = true
var is_idle = true


var reverse_to_right = false
var reverse_to_left = true

func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multipler
	else:
		collision_shape_2d.scale = Vector2(1,1)
		gravity_multipler = 1
		has_jumped = false
		speed_multipler = 1
		

	movement()
	jump()
	if dash_enabled:
		dash()

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
		print('Dash')
		gravity_multipler = 0
		velocity.x += dash_velocity * direction
			
	elif is_dashing and velocity.x !=0:
		await get_tree().create_timer(0.1).timeout
		velocity.x = move_toward(velocity.x, 0, speed_increment)
	if abs(velocity.x) < speed_limit and is_dashing:
		gravity_multipler = 1
		is_dashing = false





func jump():
	velocity.y = clamp(velocity.y,jump_velocity,fall_speed_limit)
	
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		is_idle = false
		speed_multipler = 1
		collision_shape_2d.scale = Vector2(1,0.8)
		animated_sprite_2d.play('jump')
		velocity.y = jump_velocity
		
		has_jumped = true
	if Input.is_action_just_released("Jump") and not( has_jumped and velocity.y > 0):
		velocity.y/=5
	if velocity.y > 0 and !is_dashing:
		animated_sprite_2d.play('fall')
		gravity_multipler=1.3
		
var flip_state = null
func movement():
	debug_test.text = str(velocity)

	if velocity.x!=0:
		animated_sprite_2d.speed_scale = abs(velocity.x) * 1/80
	if Input.is_action_pressed("Right")and !is_dashing:

		collision_shape_2d.position.x = 0
		reverse_to_left = true
		if is_on_floor():
			if reverse_to_right == true:
				
				animated_sprite_2d.play('turn_around')
			else:
				animated_sprite_2d.play("run")
			
		velocity.x = speed_limit * speed_multipler
		animated_sprite_2d.flip_h = false
	elif Input.is_action_pressed("Left") and !is_dashing:
		
		collision_shape_2d.position.x =10
		reverse_to_right = true
		if is_on_floor():
			if reverse_to_left == true:
				
				animated_sprite_2d.play('turn_around')
			else:
				animated_sprite_2d.play("run")
			
		velocity.x = -speed_limit * speed_multipler
		animated_sprite_2d.flip_h = true
	elif !is_dashing :
		is_idle = true
		is_running = false
		velocity.x = move_toward(velocity.x, 0, 5)
		if velocity == Vector2.ZERO:
			animated_sprite_2d.speed_scale = 1
			animated_sprite_2d.play('idle')

	if Engine.get_frames_drawn()%10 == 0:
		flip_state = animated_sprite_2d.flip_h





func _on_dash_timer_timeout() -> void:
	can_dash = true
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if "turn_around" in animated_sprite_2d.animation:
		if reverse_to_left:
			reverse_to_left = false
		if reverse_to_right:
			reverse_to_right = false
	pass # Replace with function body.
