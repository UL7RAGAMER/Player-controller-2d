extends Node2D






func _process(delta: float) -> void:
	$Area2D.global_position = get_global_mouse_position() 


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print(area)
	
	pass # Replace with function body.
