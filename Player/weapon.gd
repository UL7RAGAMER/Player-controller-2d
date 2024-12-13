extends Node2D
@onready var player: Movement = $".."

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		player.attack()
		
		
		

@onready var player_attack_data1: player_attack_data = $player_attack_data

func _on_player_attack_data_area_entered(area: Area2D) -> void:
	print(player_attack_data1.current_damage)
	if area is Hitbox:
		var atk = Attack.new()	
		atk.atk_damage = player_attack_data1.current_damage
		area.receive_damage(atk)
