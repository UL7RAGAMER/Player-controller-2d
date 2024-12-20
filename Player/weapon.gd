extends Node2D
@onready var player: Movement = $".."
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack") :
		player.attack()

		
		

@onready var attack: player_attack_data = $Attack1
@onready var attack_2: player_attack_data = $Attack2

func _on_player_attack_data_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var atk = Attack.new()
		if player.atk:
			atk.atk_damage = attack.current_damage
		elif !player.atk:
			atk.atk_damage = attack_2.current_damage
		area.receive_damage(atk)
