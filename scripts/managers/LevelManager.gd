# scripts/managers/LevelManager.gd
extends Node

signal level_changed(level_number, total_rooms)
signal game_over

var current_level: int = 1
var current_room: int = 1
var rooms_per_level: Dictionary = {
	1: 3,  # Nivel 1: 3 habitaciones (para probar)
	2: 5,  # Nivel 2: 5 habitaciones  
	3: 7   # Nivel 3: 7 habitaciones
}

func start_game():
	print("🚀 Iniciando juego...")
	current_level = 1
	current_room = 1
	load_level(current_level)

func load_level(level_number: int):
	print("📦 Cargando nivel ", level_number)
	
	# Limpiar nivel anterior
	var current_level_node = get_parent().get_node("CurrentLevel")
	for child in current_level_node.get_children():
		child.queue_free()
	
	# Crear nuevo nivel
	var level_scene = load("res://scenes/levels/Level.tscn")
	var new_level = level_scene.instantiate()
	current_level_node.add_child(new_level)
	
	# Configurar nivel
	var room_count = rooms_per_level[level_number]
	new_level.setup_level(level_number, room_count)
	
	# Conectar señales
	new_level.room_completed.connect(_on_room_completed)
	new_level.player_died.connect(_on_player_died)
	
	level_changed.emit(level_number, room_count)

func _on_room_completed():
	current_room += 1
	var current_level_node = get_parent().get_node("CurrentLevel").get_child(0)
	
	if current_room > rooms_per_level[current_level]:
		# Nivel completado
		current_level += 1
		current_room = 1
		if current_level in rooms_per_level:
			load_level(current_level)
		else:
			print("🎉 ¡Juego completado!")
	else:
		# Siguiente habitación
		current_level_node.load_room(current_room)

func _on_player_died():
	print("💀 Game Over")
	game_over.emit()
