extends Node2D
class_name Attack
@export_category('Attack stats')
@export var atk_damage : float = 1 
@export var knockback_force : float = 5
@export var critical_hit_chance : float = 0
@export var critical_hit_damage_boost : int = 100 # This value is in % so 100 here means 2 times damage
