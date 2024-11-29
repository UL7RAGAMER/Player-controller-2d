extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $Jump_timer
@onready var debug_test: Label = $"Debug test"



@export_category("Movement")
@export var speed_increment = 50
@export var speed_limit = 200
@export var fall_speed_limit = 50
@export var jump_velocity = -300
@export var gravity_multipler = 1

var has_jumped= false
func _physics_process(delta: float) -> void:
	debug_test.text = str(gravity_multipler)
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multipler
	else:
		gravity_multipler = 1
		has_jumped = false
	movement()
	jump()
		

	move_and_slide()
func jump():
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		velocity.y = clamp(velocity.y,jump_velocity,fall_speed_limit)
		has_jumped = true
	if Input.is_action_just_released("Jump"):
		velocity.y/=2
	if has_jumped and velocity.y > 0:
		gravity_multipler+=0.05
	
func movement():
	var direction := Input.get_axis("Left", "Right") 
	if direction:
		
		if velocity.x!=0:
			animated_sprite_2d.speed_scale = abs(velocity.x) * 1/80 
		if direction > 0:
			animated_sprite_2d.flip_h = false
		else :
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
		
		velocity.x += direction * speed_increment
		velocity.x = clamp(velocity.x,-speed_limit,speed_limit)
	else:
		animated_sprite_2d.speed_scale = 1
		velocity.x = move_toward(velocity.x, 0, speed_limit)
		if velocity == Vector2.ZERO:
			animated_sprite_2d.play('idle')
