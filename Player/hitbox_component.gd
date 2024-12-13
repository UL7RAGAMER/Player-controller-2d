extends Area2D
class_name Hitbox
@export var health_component : Health

func receive_damage(atk : Attack):
	if health_component:
		health_component.damage_taken(atk)
	pass
