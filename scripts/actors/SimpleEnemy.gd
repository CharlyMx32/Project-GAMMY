# scripts/actors/SimpleEnemy.gd
extends CharacterBody2D

var health: int = 30
var speed: int = 80
var player_ref: Node2D

func _ready():
	# Conectar al jugador después de un momento
	await get_tree().create_timer(0.1).timeout
	find_player()

func find_player():
	# DEBUG: Ver estructura
	var parent_room = get_parent().get_parent()
	print("🔍 Enemigo buscando jugador...")
	print("   Enemigo posición: ", global_position)
	print("   Parent room: ", parent_room.name if parent_room else "NONE")
	
	# Buscar jugador en la estructura correcta
	# El jugador está en: Level -> Player -> Player (instancia)
	var level_node = get_tree().get_current_scene()
	if level_node and level_node.has_node("Player"):
		var player_container = level_node.get_node("Player")
		if player_container.get_child_count() > 0:
			player_ref = player_container.get_child(0)
			print("   ✅ Jugador encontrado: ", player_ref.name)
			print("   🎯 Posición del jugador: ", player_ref.global_position)
		else:
			print("   ⚠️ Contenedor Player vacío")
	else:
		print("   ❌ No se pudo encontrar Level o Player")

func _physics_process(delta):
	if player_ref and is_instance_valid(player_ref):
		var direction = (player_ref.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		# DEBUG: Ver movimiento
		if velocity != Vector2.ZERO:
			print("   👹 Enemigo persiguiendo - Dir: ", direction, " Pos: ", global_position)
	else:
		# Si no encuentra jugador, moverse aleatoriamente
		if randf() < 0.02:  # 2% de chance cada frame
			velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed
			move_and_slide()

func set_player_target(player: Node2D):
	player_ref = player
	print("🎯 Jugador asignado directamente a ", name)

func take_damage(amount: int):
	health -= amount
	print("Enemigo recibió %d de daño. Vida: %d" % [amount, health])
	
	if health <= 0:
		die()

func die():
	print("💀 Enemigo simple murió!")
	# Emitir señal de muerte
	if get_parent().get_parent().has_method("_on_enemy_died"):
		get_parent().get_parent()._on_enemy_died()
	queue_free()
