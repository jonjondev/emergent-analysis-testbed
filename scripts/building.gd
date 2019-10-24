extends Area2D

export (float) var expansion_padding = 6
export (int) var health = 3000
var upgraded = false
var owning_dude

func _physics_process(delta):
	if not is_instance_valid(owning_dude):
		health = health - 1
	if health < 1500:
		print("breaking down")
	if health <= 0:
		queue_free()
		print("gone")

func spawn_dude():
	var new_dude = load("res://scenes/entities/dude.tscn").instance()
	new_dude.position = position
	get_parent().add_child(new_dude)

func _upgrade():
	upgraded = true
	$StoneSprite.visible = true
	$WoodSprite.visible = false
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "spawn_dude")
	timer.set_wait_time(1)
	timer.start()
	add_child(timer)

func _expand(owner_dude):
	var building_scene = load("res://scenes/entities/building.tscn")
	var new_building = building_scene.instance()
	new_building.position = position
	new_building.owning_dude = owner_dude
	var building_width = $WoodSprite.texture.get_size().x
	var building_height = $WoodSprite.texture.get_size().y
	var building_spacing_h = building_width * expansion_padding
	var building_spacing_v = building_height * expansion_padding
	
	var build_directions = [Vector2(building_spacing_h, 0), Vector2(-building_spacing_h, 0), Vector2(0, building_spacing_v), Vector2(0, -building_spacing_v)]
	
	for direction in build_directions:
		new_building.position = position + direction
		
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, new_building.position, [self], 2147483647, true, true)
		
		if result.empty():
			get_parent().add_child(new_building)
			return new_building