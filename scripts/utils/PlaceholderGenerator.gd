# scripts/utils/PlaceholderGenerator.gd
class_name PlaceholderGenerator

static func create_color_sprite(size: Vector2, color: Color, name: String = "Placeholder") -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.name = name
	
	# Crear imagen del color
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# Crear textura
	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture
	
	return sprite

static func create_outlined_sprite(size: Vector2, fill_color: Color, outline_color: Color, name: String = "Placeholder") -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.name = name
	
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	
	# Rellenar con color principal
	image.fill(fill_color)
	
	# Agregar borde
	for x in range(size.x):
		for y in range(size.y):
			if x == 0 or x == size.x - 1 or y == 0 or y == size.y - 1:
				image.set_pixel(x, y, outline_color)
	
	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture
	
	return sprite
