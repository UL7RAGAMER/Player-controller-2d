@tool
extends Area2D
class_name player_attack_data
var current_index :int
var current_frame: int
var frame_count:int 
var current_damage:int
@export var frames: Array[Frame_object]
@export var btn_success_add_frame:bool:
	set(v):add_frame()
@export var btn_success_add_two_frames:bool:
	set(v):add_two_frames()
@export var btn_success_add_three_frames:bool:
	set(v):add_three_frames()
@export var btn_danger_delete_all_frames:bool:
	set(v):delete_all_frames()
	
@export var btn_start : bool:
	set(v):start()
@export var btn_next : bool:
	set(v):next()
@export var btn_end : bool:
	set(v):end()
func _ready() -> void:
	current_frame = 0
	get_parent().set_editable_instance(self, true)
	collision_layer = 1
	collision_mask = 4
	pass # Replace with function body.
	

func _process(delta: float) -> void:
	pass

func add_two_frames():
	var multi_frame_index = ['A','B']
	var new_frame_objs = Frame_object.new()

	for i in range(2):
		var new_frame = Frame_node.new()
		new_frame.shape = RectangleShape2D.new()
		new_frame.name = str(current_index)+'_index_frame_' + multi_frame_index[i]
		new_frame.debug_color = Color(0.7,0,0,0.42)
		add_child(new_frame)
		new_frame.owner = get_tree().edited_scene_root
		new_frame_objs.frame.append(frame_count)
		frame_count+=1
	frames.push_back(new_frame_objs)
	current_index+=1

func add_three_frames():
	var multi_frame_index = ['A','B','C']
	var new_frame_objs = Frame_object.new()
	for i in range(3):
		var new_frame = Frame_node.new()
		new_frame.shape = RectangleShape2D.new()
		new_frame.name = str(current_index)+'_index_frame_' + multi_frame_index[i]
		new_frame.debug_color = Color(0.7,0,0,0.42)
		add_child(new_frame)
		new_frame.owner = get_tree().edited_scene_root
		new_frame_objs.frame.append(frame_count)
		frame_count+=1
	frames.push_back(new_frame_objs)
	current_index+=1

func add_frame():
	var new_frame = Frame_node.new()
	new_frame.shape = RectangleShape2D.new()
	new_frame.name = str(current_index)+'_index_frame'
	new_frame.debug_color = Color(0.7,0,0,0.42)
	add_child(new_frame)
	new_frame.owner = get_tree().edited_scene_root
	var new_frame_objs = Frame_object.new()
	new_frame_objs.frame.append(frame_count)
	frames.push_back(new_frame_objs)
	current_index+=1
	frame_count+=1
func delete_all_frames():
	for i in get_children(true):
		i.queue_free()
	current_index = 0
	current_frame = 0
	frame_count = 0
	frames.clear()

	
func start():
	current_frame = 0
	var idx = 0
	var children: Array[Frame_node] 
	for i in get_children():
		children.push_back(i)#Did this in a werid way for syntax_highlighting
	for i in frames[0].frame:
		children[i].visible = true
		children[i].disabled = false
		current_damage = children[i].damage
	for i in range(1,frames.size()):
		for j in frames[i].frame:
			children[j].visible = false
			children[j].disabled = true
	
	
func next():
	assert(!(frames.size()<= current_frame),' Out of bounds of frame')
	var children: Array[Frame_node]
	for i in get_children():
		children.push_back(i)
	for i in frames[current_frame].frame:
		children[i].visible = false
		children[i].disabled = true
	for i in frames[current_frame+1].frame:
		children[i].visible = true
		children[i].disabled = false
		current_damage = children[i].damage
		print(current_damage)
	current_frame+=1
	

func end():
	var children: Array[Frame_node]
	for i in get_children():
		children.push_back(i)
	for i in range(0,frames.size()):
		for j in frames[i].frame:
			children[j].visible = false
			children[j].disabled = true
			
			
			
#Below lies pain
#func loadd():
	#var save_file = FileAccess.open(save_path, FileAccess.READ)
	#var data:Array[Frame_object] = save_file.get_var(true)
	#frames.clear()
	#frames.append_array(data)
	#print(data)
	#var idx = 0
	#var name = []
	#for i in get_children():
		#name.append((i.name).validate_node_name())
		#i.queue_free()
	#for i in frames:
		#for j in i.frame:
			#j.name = 'a'
			#print(name[idx])
			#
			#add_child(j)
			#j.owner = get_tree().edited_scene_root
			#j.name = name[idx] + ' '
			#j.name = j.name.rstrip('2')
			#idx+=1
	#save_file.close()
	

#func _notification(what: int) -> void:
	#if what == NOTIFICATION_EDITOR_PRE_SAVE:
		#pass
#func save():
	#var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	#save_file.store_var(frames,true)
	#save_file.close()
	#pass # Replace with function body.
#func sync():
	#save()
	#loadd()
