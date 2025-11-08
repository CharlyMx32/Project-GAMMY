# scripts/actors/Actor.gd
class_name Actor
extends CharacterBody2D

@export_category("Actor Settings")
@export var actor_name: String = "Actor"
@export var max_health: int = 100
@export var speed: int = 150
@export var placeholder_color: Color = Color.WHITE
@export var placeholder_size: Vector2 = Vector2(16, 16)

var current_health: int

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	current_health = max_health
	setup_placeholder()

func setup_placeholder():
	# Si no hay sprite, crear uno temporal
	if not has_node("Sprite2D"):
		var new_sprite = Sprite2D.new()
		new_sprite.name = "Sprite2D"
		add_child(new_sprite)
		sprite = new_sprite
	
	# Si no hay textura, crear placeholder
	if not sprite.texture:
		sprite.texture = generate_placeholder_texture()

func generate_placeholder_texture() -> Texture2D:
	var image = Image.create(int(placeholder_size.x), int(placeholder_size.y), false, Image.FORMAT_RGBA8)
	image.fill(placeholder_color)
	
	# Agregar borde negro para mejor visibilidad
	for x in range(int(placeholder_size.x)):
		for y in range(int(placeholder_size.y)):
			if x == 0 or x == placeholder_size.x - 1 or y == 0 or y == placeholder_size.y - 1:
				image.set_pixel(x, y, Color.BLACK)
	
	return ImageTexture.create_from_image(image)

func take_damage(amount: int):
	current_health -= amount
	print("%s recibió %d de daño. Vida: %d/%d" % [actor_name, amount, current_health, max_health])
	
	if current_health <= 0:
		die()

func die():
	print("%s murió!" % actor_name)
	queue_free()
