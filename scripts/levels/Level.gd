# scripts/levels/Level.gd
extends Node2D

signal room_completed
signal player_died

var level_number: int
var total_rooms: int
var current_room: int = 1

@onready var current_room_node = $CurrentRoom
@onready var player_container = $Player  # Este es el contenedor VACÍO

var current_player: CharacterBody2D  # Esta es la instancia REAL de Player.tscn

func setup_level(level_num: int, room_count: int):
	level_number = level_num
	total_rooms = room_count
	print("🏰 Nivel %d configurado con %d habitaciones" % [level_num, room_count])
	
	# Asegurar que tenemos jugador
	setup_player()
	load_room(1)

func setup_player():
	# Limpiar contenedor por si acaso
	for child in player_container.get_children():
		child.queue_free()
	
	# Cargar e instanciar Player.tscn
	var player_scene = load("res://scenes/actors/Player.tscn")
	if player_scene:
		current_player = player_scene.instantiate()
		player_container.add_child(current_player)
		current_player.player_died.connect(_on_player_died)
		print("👤 Jugador REAL instanciado desde Player.tscn")
		print("   Posición: ", current_player.position)
		print("   ¿En árbol?: ", current_player.is_inside_tree())
	else:
		print("💥 CRÍTICO: No se pudo cargar Player.tscn")

func load_room(room_number: int):
	current_room = room_number
	print("🚪 Cargando habitación %d/%d" % [room_number, total_rooms])
	
	# Limpiar habitación anterior
	for child in current_room_node.get_children():
		child.queue_free()
	
	# Crear nueva habitación
	var room_scene = load("res://scenes/rooms/Room.tscn")
	var new_room = room_scene.instantiate()
	current_room_node.add_child(new_room)
	
	# Configurar habitación
	new_room.setup_room(level_number, room_number, room_number == total_rooms)
	new_room.room_cleared.connect(_on_room_cleared)
	
	# Posicionar jugador
	if current_player:
		var start_pos = new_room.get_player_start_position()
		current_player.position = start_pos
		print("🎯 Jugador posicionado en: ", start_pos)
		
		# Conectar jugador a enemigos (para IA)
		connect_player_to_enemies(new_room)

func connect_player_to_enemies(room: Node2D):
	var enemies_node = room.get_node("Enemies")
	print("🔗 Conectando %d enemigos al jugador..." % enemies_node.get_child_count())
	
	for enemy in enemies_node.get_children():
		print("   👹 Conectando enemigo: ", enemy.name)
		if enemy.has_method("set_player_target") and current_player:
			enemy.set_player_target(current_player)
			print("     ✅ Jugador conectado a ", enemy.name)
		elif enemy.has_method("find_player"):
			enemy.find_player()
			print("     🔍 Llamando find_player en ", enemy.name)

func _on_room_cleared():
	print("✅ Habitación %d completada!" % current_room)
	room_completed.emit()

func _on_player_died():
	print("💀 Jugador murió en el nivel!")
	player_died.emit()
