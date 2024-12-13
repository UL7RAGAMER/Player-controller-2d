extends Node2D
class_name Health
@export_category('Health Stats')
@export var max_health:float = 10
var health : float 

@export var hitbox : Hitbox

func _ready() -> void:
	health = max_health
func damage_taken(attack:Attack):
	
	health -= attack.atk_damage
	if health <=0:
		get_parent().queue_free()
	pass
	
