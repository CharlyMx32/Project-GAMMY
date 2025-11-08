# scripts/rooms/Room.gd
extends Node2D

signal room_cleared

var level: int
var room_number: int
var is_boss_room: bool
var enemies: Array = []

@onready var enemies_node = $Enemies

func setup_room(level_num: int, room_num: int, boss_room: bool):
	level = level_num
	room_number = room_num
	is_boss_room = boss_room
	
	print("🧩 Configurando habitación %d (Nivel %d, Boss: %s)" % [room_num, level_num, str(boss_room)])
	
	spawn_simple_enemies()

func spawn_simple_enemies():
	# Limpiar enemigos anteriores
	for child in enemies_node.get_children():
		child.queue_free()
	
	# Crear enemigos simples directamente
	var enemy_count = level + room_number
	
	for i in range(enemy_count):
		var enemy = create_simple_enemy(i)
		enemies_node.add_child(enemy)
		
		# Posicionar aleatoriamente
		var spawn_pos = Vector2(
			randf_range(100, 500),
			randf_range(100, 250)
		)
		enemy.position = spawn_pos
		
		enemies.append(enemy)
	
	print("👾 Generados %d enemigos simples" % enemy_count)

func create_simple_enemy(index: int) -> CharacterBody2D:
	var enemy = CharacterBody2D.new()
	enemy.name = "SimpleEnemy_%d" % index
	
	# Agregar sprite
	var sprite = Sprite2D.new()
	enemy.add_child(sprite)
	
	# Crear textura de color (rojo para enemigos)
	var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color.RED)
	
	# Borde negro
	for x in range(16):
		for y in range(16):
			if x == 0 or x == 15 or y == 0 or y == 15:
				image.set_pixel(x, y, Color.BLACK)
	
	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture
	
	# Agregar colisión
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	collision.shape = shape
	enemy.add_child(collision)
	
	# Agregar script básico
	enemy.set_script(load("res://scripts/actors/SimpleEnemy.gd"))
	
	return enemy

func _on_enemy_died():
	# Verificar si todos los enemigos murieron
	var alive_enemies = 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			alive_enemies += 1
	
	print("🎯 Enemigos vivos: %d/%d" % [alive_enemies, enemies.size()])
	
	if alive_enemies <= 0:
		print("✅ Habitación completada!")
		room_cleared.emit()

func get_player_start_position() -> Vector2:
	return Vector2(320, 180)  # Centro de pantalla
