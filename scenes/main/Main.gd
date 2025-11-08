# scripts/main/Main.gd
extends Node

@onready var level_manager = $LevelManager

func _ready():
	print("🎮 Juego iniciado!")
	
	# VERIFICAR si level_manager existe
	if level_manager:
		print("✅ LevelManager encontrado via @onready")
		level_manager.start_game()
	else:
		# Buscar alternativas si @onready falló
		var found_manager = find_child("LevelManager")
		if found_manager:
			print("✅ LevelManager encontrado via find_child()")
			found_manager.start_game()
		else:
			# Último intento - buscar por método
			for child in get_children():
				if child.has_method("start_game"):
					print("✅ LevelManager encontrado por método")
					child.start_game()
					return
			
			print("💥 CRÍTICO: LevelManager no existe")
			print("Hijos disponibles:", get_children())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
