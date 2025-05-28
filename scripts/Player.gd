extends CharacterBody2D

@export var gravity = 500.0
@export var walk_speed = 200
@export var jump_speed = -300
@export var health = 100
@export var freeze_cost = 1
@export var break_cost = 1
@export var charge_cost = 1

@onready var player_sprite = $PlayerSprite
@onready var default_collision = $DefaultCollision
@onready var spawn_air = preload("res://scene/FrozenAir.tscn")
@onready var basic_tiles: TileMapLayer = get_parent().get_node("BasicTiles")
@onready var healthbar = get_parent().get_node("HUD/HealthBar")
@onready var start_delay_timer = $StartDelayTimer

@onready var area_up = $CheckUp
@onready var area_down = $CheckDown
@onready var area_right = $CheckRight
@onready var area_left = $CheckLeft

var footstep_cooldown: float = 0.0
var footstep_delay: float = 0.37

var state: SignalBus.States = SignalBus.States.IDLE
var form: SignalBus.Forms = SignalBus.Forms.FORM_WHITE
var last_direction = 1 # 1 = right, -1 = left
var tomato_count = 0.0

var exists_up = false
var exists_down = false
var exists_left = false
var exists_right = false

var bodies_up: Array[Node2D] = []
var bodies_down: Array[Node2D] = []
var bodies_left: Array[Node2D] = []
var bodies_right: Array[Node2D] = []

var can_move: bool = false

func _ready() -> void:
	SignalBus.dead.connect(_pause)
	SignalBus.is_paused.connect(_pause)
	SignalBus.unpause.connect(_resume)
	SignalBus.is_paused_trans.connect(_pause)
	SignalBus.unpause_trans.connect(_resume)
	await healthbar.ready
	healthbar.init_health(health)
	
	set_state_form(SignalBus.States.IDLE, SignalBus.Forms.FORM_WHITE)
	
	SignalBus.tomato_pickup.connect(add_tomato)
	SignalBus.finish_transformation.connect(set_state_form)
	
	start_delay_timer.start()
	await start_delay_timer.timeout
	can_move = true

func set_state_form(new_state: SignalBus.States, new_form: SignalBus.Forms):
	state = new_state
	form = new_form
	
	SignalBus.current_form = form
	
	match state:
		SignalBus.States.IDLE:
			match form:
				SignalBus.Forms.FORM_WHITE:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("idle_white")
				SignalBus.Forms.FORM_RED:
					jump_speed = -420
					walk_speed = 250
					player_sprite.play("idle_red")
				SignalBus.Forms.FORM_BLUE:
					jump_speed = -250
					walk_speed = 180
					player_sprite.play("idle_blue")
				SignalBus.Forms.FORM_YELLOW:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("idle_yellow")
			
		SignalBus.States.RUN:
			match form:
				SignalBus.Forms.FORM_WHITE:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("run_white")
				SignalBus.Forms.FORM_RED:
					jump_speed = -420
					walk_speed = 250
					player_sprite.play("run_red")
				SignalBus.Forms.FORM_BLUE:
					jump_speed = -250
					walk_speed = 180
					player_sprite.play("run_blue")
				SignalBus.Forms.FORM_YELLOW:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("run_yellow")
		
		SignalBus.States.JUMP:
			match form:
				SignalBus.Forms.FORM_WHITE:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("jump_white")
				SignalBus.Forms.FORM_RED:
					jump_speed = -420
					walk_speed = 250
					player_sprite.play("jump_red")
				SignalBus.Forms.FORM_BLUE:
					jump_speed = -250
					walk_speed = 180
					player_sprite.play("jump_blue")
				SignalBus.Forms.FORM_YELLOW:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("jump_yellow")
			
		SignalBus.States.INTERACT_UP:
			match form:
				SignalBus.Forms.FORM_WHITE:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("interact_up_white")
				SignalBus.Forms.FORM_RED:
					jump_speed = -420
					walk_speed = 250
					player_sprite.play("interact_up_red")
				SignalBus.Forms.FORM_BLUE:
					jump_speed = -250
					walk_speed = 180
					player_sprite.play("interact_up_blue")
				SignalBus.Forms.FORM_YELLOW:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("interact_up_yellow")
					
		SignalBus.States.INTERACT_RIGHT:
			match form:
				SignalBus.Forms.FORM_WHITE:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("interact_right_white")
				SignalBus.Forms.FORM_RED:
					jump_speed = -420
					walk_speed = 250
					player_sprite.play("interact_right_red")
				SignalBus.Forms.FORM_BLUE:
					jump_speed = -250
					walk_speed = 180
					player_sprite.play("interact_right_blue")
				SignalBus.Forms.FORM_YELLOW:
					jump_speed = -300
					walk_speed = 200
					player_sprite.play("interact_right_yellow")

func _physics_process(delta):
	if !can_move: return
	velocity.y += delta * gravity
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		last_direction = sign(direction)
	
	if direction >= 1:
		player_sprite.flip_h = false
	elif direction <= -1:
		player_sprite.flip_h = true
	
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		if is_on_floor():
			if footstep_cooldown <= 0:
				SignalBus.play_sound.emit("footsteps-tap-short.ogg")
				footstep_cooldown = footstep_delay
			else:
				footstep_cooldown -= delta
		velocity.x = walk_speed * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	else:
		footstep_cooldown = 0
		
	handle_movement()
	
	move_and_slide()
		
func handle_movement():
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		if is_on_floor():
			set_state_form(SignalBus.States.RUN, form)
		elif !is_on_floor():
			pass
		velocity.x += walk_speed
	
	if Input.is_action_pressed("move_left"):
		if is_on_floor():
			set_state_form(SignalBus.States.RUN, form)
		elif !is_on_floor():
			pass
		velocity.x -= walk_speed
			
	if Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left") and state == SignalBus.States.RUN:
		set_state_form(SignalBus.States.IDLE, form)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SignalBus.play_sound.emit("jump_07.wav")
		set_state_form(SignalBus.States.JUMP, form)
		velocity.y += jump_speed
		
	if Input.is_action_just_pressed("interact"):
		SignalBus.play_sound.emit("interact.mp3")
		match form:
			SignalBus.Forms.FORM_WHITE:
				pass
			SignalBus.Forms.FORM_YELLOW:
				SignalBus.hp_down.emit(break_cost)
				break_object()
			SignalBus.Forms.FORM_RED:
				SignalBus.hp_down.emit(charge_cost)
				push_object()
			SignalBus.Forms.FORM_BLUE:
				SignalBus.hp_down.emit(freeze_cost)
				interact_blue()

func add_tomato():
	SignalBus.player_tomato += 1.0	

func get_mouse_cardinal_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position

	if abs(to_mouse.x) > abs(to_mouse.y):
		return Vector2.RIGHT if to_mouse.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if to_mouse.y > 0 else Vector2.UP

func interact_blue():
	var offset_dir := get_mouse_cardinal_direction()
	var rotateby := 0
	var spawn_distance = 64
	
	match offset_dir:
		Vector2.UP:
			set_state_form(SignalBus.States.INTERACT_UP, form)
			if exists_up: return freeze_object(offset_dir)
			offset_dir = Vector2.UP
			rotateby = 0
			spawn_distance = 32
		Vector2.DOWN:
			if exists_down: return freeze_object(offset_dir)
			offset_dir = Vector2.DOWN
			rotateby = 0
			spawn_distance = 64
		Vector2.RIGHT:
			set_state_form(SignalBus.States.INTERACT_RIGHT, form)
			if exists_right: return freeze_object(offset_dir)
			rotateby = 270
			spawn_distance = 32
		Vector2.LEFT:
			set_state_form(SignalBus.States.INTERACT_RIGHT, form)
			if exists_left: return freeze_object(offset_dir)
			rotateby = 90
			spawn_distance = 32

	var tile = spawn_air.instantiate()
	get_tree().current_scene.add_child(tile)
	
	tile.global_position = global_position + offset_dir * spawn_distance
	tile.rotation = deg_to_rad(rotateby)
		
func break_object():
	var targets: Array[Node2D] = []
	var dir = get_mouse_cardinal_direction()

	match dir:
		Vector2.UP:
			set_state_form(SignalBus.States.INTERACT_UP, form)
			targets = bodies_up
		Vector2.DOWN:
			targets = bodies_down
		Vector2.RIGHT:
			set_state_form(SignalBus.States.INTERACT_RIGHT, form)
			targets = bodies_right
		Vector2.LEFT:
			set_state_form(SignalBus.States.INTERACT_RIGHT, form)
			targets = bodies_left
		
	for target in targets:
		if target is StaticBody2D:
			var original_pos = target.global_position
			var tween = get_tree().create_tween()
			tween.set_loops(3)
			tween.tween_property(target, "global_position", original_pos + Vector2(5, 0), 0.05)
			tween.tween_property(target, "global_position", original_pos - Vector2(5, 0), 0.05)
			tween.tween_property(target, "global_position", original_pos, 0.05)
			tween.tween_callback(Callable(target, "queue_free"))
			
			await tween.finished
			SignalBus.play_sound.emit("Block Break 1.wav")
		else:
			SignalBus.break_me.emit(target)

func push_object(push_force := 1.0):  # Adding a default push_force parameter
	var dir = get_mouse_cardinal_direction()
	var offset = dir * 64 * push_force  # Scale the push distance by push_force
	var player_offset = -dir * 64 * push_force  # Opposite direction for player
	var targets: Array[Node2D] = []
	
	match dir:
		Vector2.UP: targets = bodies_up
		Vector2.DOWN: targets = bodies_down
		Vector2.LEFT: targets = bodies_left
		Vector2.RIGHT: targets = bodies_right
	
	for target in targets:
		if target is StaticBody2D:
			var new_pos = target.global_position + offset
			
			var space_state = get_world_2d().direct_space_state
			var params = PhysicsRayQueryParameters2D.create(
				target.global_position,
				new_pos,
				target.collision_mask
			)
			var hit = space_state.intersect_ray(params)
			
			if not hit:
				var tween = get_tree().create_tween()
				tween.tween_property(target, "global_position", new_pos, 0.3)
				tween.set_ease(Tween.EASE_IN_OUT)
		
		else:
			SignalBus.push_me.emit(target, dir)

func _on_check_up_body_entered(body: Node2D) -> void:
	exists_up = true
	bodies_up.append(body)

func _on_check_down_body_entered(body: Node2D) -> void:
	exists_down = true
	bodies_down.append(body)

func _on_check_right_body_entered(body: Node2D) -> void:
	exists_right = true
	bodies_right.append(body)

func _on_check_left_body_entered(body: Node2D) -> void:
	exists_left = true
	bodies_left.append(body)

func _on_check_left_body_exited(body: Node2D) -> void:
	exists_left = false
	bodies_left.erase(body)
	
func _on_check_right_body_exited(body: Node2D) -> void:
	exists_right = false
	bodies_right.erase(body)

func _on_check_down_body_exited(body: Node2D) -> void:
	exists_down = false
	bodies_down.erase(body)

func _on_check_up_body_exited(body: Node2D) -> void:
	exists_up = false
	bodies_up.erase(body)
	
func take_damage(dmg):
	SignalBus.hp_down.emit(dmg)
	
func freeze_object(dir: Vector2):
	var targets
	match dir:
		Vector2.UP:
			targets = bodies_up
		Vector2.DOWN:
			targets = bodies_down
		Vector2.RIGHT:
			targets = bodies_right
		Vector2.LEFT:
			targets = bodies_left
		
	for target in targets:
		if target.is_in_group("affectable_blocks"):
			SignalBus.freeze_me.emit(target)

func _pause():
	set_physics_process(false)
	

func _resume():
	set_physics_process(true)
