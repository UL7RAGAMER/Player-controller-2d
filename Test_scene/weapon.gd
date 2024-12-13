extends Area2D




@onready var frame_node: Frame_node = $Frame_node

func _on_area_entered(area) -> void:
	if area is Hitbox:
		var atk = Attack.new()
		atk.atk_damage = frame_node.damage
		area.receive_damage(atk)
	pass # Replace with function body.
