# ===========================================
# PIXEL ART HELPER
# Path: scripts/utilities/PixelArtHelper.gd
# Helper functions for creating simple pixel art sprites
# ===========================================
class_name PixelArtHelper

# Draw a pixel at x,y with color
static func draw_pixel(image: Image, x: int, y: int, color: Color):
	if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
		image.set_pixel(x, y, color)

# Draw a filled rectangle
static func draw_rect(image: Image, rect: Rect2i, color: Color):
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			draw_pixel(image, x, y, color)

# Draw a rectangle outline
static func draw_rect_outline(image: Image, rect: Rect2i, color: Color):
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		draw_pixel(image, x, rect.position.y, color)
		draw_pixel(image, x, rect.position.y + rect.size.y - 1, color)
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		draw_pixel(image, rect.position.x, y, color)
		draw_pixel(image, rect.position.x + rect.size.x - 1, y, color)

# Draw a line from start to end
static func draw_line(image: Image, start: Vector2i, end: Vector2i, color: Color):
	var dx = abs(end.x - start.x)
	var dy = abs(end.y - start.y)
	var sx = 1 if start.x < end.x else -1
	var sy = 1 if start.y < end.y else -1
	var err = dx - dy
	var x = start.x
	var y = start.y
	
	while true:
		draw_pixel(image, x, y, color)
		if x == end.x and y == end.y:
			break
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x += sx
		if e2 < dx:
			err += dx
			y += sy

# Draw a filled circle
static func draw_circle(image: Image, center: Vector2i, radius: int, color: Color):
	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			var dist_sq = (x - center.x) * (x - center.x) + (y - center.y) * (y - center.y)
			if dist_sq <= radius * radius:
				draw_pixel(image, x, y, color)

# Create Guard Tower sprite (watchtower with red star)
static func create_guard_tower_sprite() -> ImageTexture:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Tower base (dark brown)
	draw_rect(image, Rect2i(10, 18, 12, 14), Color(0.3, 0.2, 0.1))
	
	# Tower top platform (brown)
	draw_rect(image, Rect2i(8, 14, 16, 4), Color(0.4, 0.3, 0.2))
	
	# Roof (red)
	for i in range(6):
		draw_line(image, Vector2i(8 + i, 8 + i), Vector2i(23 - i, 8 + i), Color(0.7, 0.1, 0.1))
	
	# Windows (dark)
	draw_rect(image, Rect2i(13, 20, 3, 3), Color(0.1, 0.1, 0.1))
	draw_rect(image, Rect2i(13, 25, 3, 3), Color(0.1, 0.1, 0.1))
	
	# Red star on top
	draw_pixel(image, 16, 4, Color.RED)
	draw_pixel(image, 15, 5, Color.RED)
	draw_pixel(image, 16, 5, Color.RED)
	draw_pixel(image, 17, 5, Color.RED)
	draw_pixel(image, 16, 6, Color.RED)
	
	return ImageTexture.create_from_image(image)

# Create Propaganda Speaker sprite (speaker on pole)
static func create_propaganda_speaker_sprite() -> ImageTexture:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Pole (gray)
	draw_rect(image, Rect2i(14, 8, 4, 24), Color(0.4, 0.4, 0.4))
	
	# Speaker body (red)
	draw_rect(image, Rect2i(8, 10, 16, 8), Color(0.8, 0.2, 0.2))
	
	# Speaker grill (dark red)
	for i in range(3):
		draw_line(image, Vector2i(10, 12 + i * 2), Vector2i(22, 12 + i * 2), Color(0.5, 0.1, 0.1))
	
	# Sound waves (yellow)
	draw_pixel(image, 25, 12, Color(1, 1, 0, 0.6))
	draw_pixel(image, 26, 13, Color(1, 1, 0, 0.4))
	draw_pixel(image, 25, 16, Color(1, 1, 0, 0.6))
	draw_pixel(image, 26, 15, Color(1, 1, 0, 0.4))
	
	# Red star badge
	draw_pixel(image, 16, 14, Color.RED)
	draw_pixel(image, 15, 15, Color.RED)
	draw_pixel(image, 16, 15, Color.RED)
	draw_pixel(image, 17, 15, Color.RED)
	
	return ImageTexture.create_from_image(image)

# Create Bureaucratic Office sprite (small building)
static func create_bureaucratic_office_sprite() -> ImageTexture:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Building body (gray)
	draw_rect(image, Rect2i(6, 10, 20, 22), Color(0.5, 0.5, 0.5))
	
	# Windows (dark)
	draw_rect(image, Rect2i(9, 13, 4, 4), Color(0.2, 0.2, 0.3))
	draw_rect(image, Rect2i(19, 13, 4, 4), Color(0.2, 0.2, 0.3))
	draw_rect(image, Rect2i(9, 20, 4, 4), Color(0.2, 0.2, 0.3))
	draw_rect(image, Rect2i(19, 20, 4, 4), Color(0.2, 0.2, 0.3))
	
	# Door (brown)
	draw_rect(image, Rect2i(13, 25, 6, 7), Color(0.3, 0.2, 0.1))
	
	# Roof (dark gray)
	draw_rect(image, Rect2i(4, 8, 24, 2), Color(0.3, 0.3, 0.3))
	
	# Paperwork flying out window (white)
	draw_pixel(image, 24, 15, Color.WHITE)
	draw_pixel(image, 25, 14, Color.WHITE)
	draw_pixel(image, 26, 16, Color(0.9, 0.9, 0.9))
	
	return ImageTexture.create_from_image(image)

# Create Missile Station sprite (rocket launcher)
static func create_missile_station_sprite() -> ImageTexture:
	var image = Image.create(40, 40, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Base platform (dark gray)
	draw_rect(image, Rect2i(8, 28, 24, 12), Color(0.3, 0.3, 0.3))
	
	# Support struts (gray)
	draw_line(image, Vector2i(12, 28), Vector2i(16, 20), Color(0.4, 0.4, 0.4))
	draw_line(image, Vector2i(28, 28), Vector2i(24, 20), Color(0.4, 0.4, 0.4))
	
	# Missile body (red)
	draw_rect(image, Rect2i(16, 8, 8, 18), Color(0.8, 0.2, 0.2))
	
	# Missile nose cone (yellow)
	draw_pixel(image, 19, 6, Color.YELLOW)
	draw_pixel(image, 20, 6, Color.YELLOW)
	draw_pixel(image, 18, 7, Color.YELLOW)
	draw_pixel(image, 19, 7, Color.YELLOW)
	draw_pixel(image, 20, 7, Color.YELLOW)
	draw_pixel(image, 21, 7, Color.YELLOW)
	
	# Missile fins (dark red)
	draw_rect(image, Rect2i(14, 22, 2, 4), Color(0.5, 0.1, 0.1))
	draw_rect(image, Rect2i(24, 22, 2, 4), Color(0.5, 0.1, 0.1))
	
	# Red star emblem
	draw_pixel(image, 20, 15, Color.RED)
	draw_pixel(image, 19, 16, Color.RED)
	draw_pixel(image, 20, 16, Color.RED)
	draw_pixel(image, 21, 16, Color.RED)
	
	return ImageTexture.create_from_image(image)

# ========== ENEMY SPRITES ==========

# Create Businessman sprite (suit and briefcase)
static func create_businessman_sprite() -> ImageTexture:
	var image = Image.create(16, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Head (skin tone)
	draw_rect(image, Rect2i(6, 2, 4, 4), Color(0.9, 0.7, 0.6))
	
	# Hat (black)
	draw_rect(image, Rect2i(5, 0, 6, 2), Color(0.1, 0.1, 0.1))
	
	# Suit body (dark blue)
	draw_rect(image, Rect2i(5, 6, 6, 8), Color(0.1, 0.1, 0.3))
	
	# Tie (red - capitalist red!)
	draw_rect(image, Rect2i(7, 6, 2, 6), Color(0.7, 0.1, 0.1))
	
	# Legs (dark blue pants)
	draw_rect(image, Rect2i(6, 14, 2, 6), Color(0.05, 0.05, 0.2))
	draw_rect(image, Rect2i(8, 14, 2, 6), Color(0.05, 0.05, 0.2))
	
	# Shoes (black)
	draw_rect(image, Rect2i(5, 20, 3, 4), Color(0.1, 0.1, 0.1))
	draw_rect(image, Rect2i(8, 20, 3, 4), Color(0.1, 0.1, 0.1))
	
	# Briefcase (brown)
	draw_rect(image, Rect2i(11, 10, 3, 4), Color(0.4, 0.25, 0.1))
	
	# Dollar sign on briefcase (green)
	draw_pixel(image, 12, 11, Color(0.2, 0.8, 0.2))
	draw_pixel(image, 12, 12, Color(0.2, 0.8, 0.2))
	
	return ImageTexture.create_from_image(image)

# Create Tourist sprite (casual clothes and camera)
static func create_tourist_sprite() -> ImageTexture:
	var image = Image.create(16, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Head (skin tone)
	draw_rect(image, Rect2i(6, 2, 4, 4), Color(0.9, 0.7, 0.6))
	
	# Sun hat (yellow)
	draw_rect(image, Rect2i(4, 0, 8, 2), Color(0.9, 0.8, 0.2))
	
	# Hawaiian shirt (bright)
	draw_rect(image, Rect2i(5, 6, 6, 6), Color(0.2, 0.7, 0.9))
	# Flower pattern (pink)
	draw_pixel(image, 6, 8, Color(1, 0.4, 0.6))
	draw_pixel(image, 9, 7, Color(1, 0.4, 0.6))
	
	# Shorts (khaki)
	draw_rect(image, Rect2i(5, 12, 6, 4), Color(0.7, 0.6, 0.4))
	
	# Legs (skin)
	draw_rect(image, Rect2i(6, 16, 2, 4), Color(0.9, 0.7, 0.6))
	draw_rect(image, Rect2i(8, 16, 2, 4), Color(0.9, 0.7, 0.6))
	
	# Shoes (white sneakers)
	draw_rect(image, Rect2i(5, 20, 3, 4), Color(0.9, 0.9, 0.9))
	draw_rect(image, Rect2i(8, 20, 3, 4), Color(0.9, 0.9, 0.9))
	
	# Camera (black)
	draw_rect(image, Rect2i(11, 8, 3, 3), Color(0.2, 0.2, 0.2))
	# Camera lens (gray)
	draw_pixel(image, 12, 9, Color(0.5, 0.5, 0.5))
	
	return ImageTexture.create_from_image(image)

# Create Oligarch sprite (fancy suit with gold)
static func create_oligarch_sprite() -> ImageTexture:
	var image = Image.create(16, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Head (skin tone)
	draw_rect(image, Rect2i(6, 2, 4, 4), Color(0.9, 0.7, 0.6))
	
	# Top hat (black with gold band)
	draw_rect(image, Rect2i(5, 0, 6, 3), Color(0.1, 0.1, 0.1))
	draw_line(image, Vector2i(5, 2), Vector2i(10, 2), Color(0.9, 0.8, 0.2))
	
	# Fancy suit (dark with gold trim)
	draw_rect(image, Rect2i(5, 6, 6, 8), Color(0.15, 0.1, 0.2))
	# Gold buttons
	draw_pixel(image, 7, 7, Color(0.9, 0.8, 0.2))
	draw_pixel(image, 7, 9, Color(0.9, 0.8, 0.2))
	draw_pixel(image, 7, 11, Color(0.9, 0.8, 0.2))
	
	# Tie (gold)
	draw_rect(image, Rect2i(7, 6, 2, 6), Color(0.9, 0.8, 0.2))
	
	# Legs (black pants)
	draw_rect(image, Rect2i(6, 14, 2, 6), Color(0.1, 0.1, 0.1))
	draw_rect(image, Rect2i(8, 14, 2, 6), Color(0.1, 0.1, 0.1))
	
	# Shiny shoes (black with shine)
	draw_rect(image, Rect2i(5, 20, 3, 4), Color(0.1, 0.1, 0.1))
	draw_rect(image, Rect2i(8, 20, 3, 4), Color(0.1, 0.1, 0.1))
	draw_pixel(image, 6, 21, Color(0.3, 0.3, 0.3))
	draw_pixel(image, 9, 21, Color(0.3, 0.3, 0.3))
	
	# Money bag (brown with $ sign)
	draw_rect(image, Rect2i(11, 10, 4, 5), Color(0.5, 0.3, 0.1))
	draw_pixel(image, 12, 12, Color(0.2, 0.8, 0.2))
	draw_pixel(image, 13, 12, Color(0.2, 0.8, 0.2))
	
	return ImageTexture.create_from_image(image)

# Create CEO Boss sprite (large and intimidating)
static func create_ceo_sprite() -> ImageTexture:
	var image = Image.create(24, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Head (larger, angry)
	draw_rect(image, Rect2i(8, 3, 8, 6), Color(0.9, 0.6, 0.5))
	
	# Angry eyes (red)
	draw_pixel(image, 10, 5, Color(0.8, 0.1, 0.1))
	draw_pixel(image, 14, 5, Color(0.8, 0.1, 0.1))
	
	# Crown (gold - king of capitalism)
	draw_rect(image, Rect2i(7, 0, 10, 3), Color(0.9, 0.8, 0.2))
	draw_pixel(image, 8, 0, Color(1, 0.9, 0.3))
	draw_pixel(image, 12, 0, Color(1, 0.9, 0.3))
	draw_pixel(image, 15, 0, Color(1, 0.9, 0.3))
	
	# Expensive suit (dark pinstripe)
	draw_rect(image, Rect2i(6, 9, 12, 12), Color(0.1, 0.1, 0.15))
	# Pinstripes
	for y in range(9, 21, 2):
		draw_pixel(image, 8, y, Color(0.2, 0.2, 0.3))
		draw_pixel(image, 11, y, Color(0.2, 0.2, 0.3))
		draw_pixel(image, 14, y, Color(0.2, 0.2, 0.3))
	
	# Gold tie
	draw_rect(image, Rect2i(10, 9, 4, 10), Color(0.9, 0.8, 0.2))
	
	# Legs (dark)
	draw_rect(image, Rect2i(8, 21, 3, 7), Color(0.05, 0.05, 0.1))
	draw_rect(image, Rect2i(13, 21, 3, 7), Color(0.05, 0.05, 0.1))
	
	# Fancy shoes
	draw_rect(image, Rect2i(7, 28, 4, 4), Color(0.1, 0.1, 0.1))
	draw_rect(image, Rect2i(13, 28, 4, 4), Color(0.1, 0.1, 0.1))
	draw_pixel(image, 8, 29, Color(0.4, 0.4, 0.4))
	draw_pixel(image, 14, 29, Color(0.4, 0.4, 0.4))
	
	# Cigar (brown)
	draw_rect(image, Rect2i(18, 6, 4, 1), Color(0.4, 0.2, 0.1))
	# Smoke (gray)
	draw_pixel(image, 21, 5, Color(0.7, 0.7, 0.7, 0.5))
	draw_pixel(image, 22, 4, Color(0.6, 0.6, 0.6, 0.3))
	
	return ImageTexture.create_from_image(image)
