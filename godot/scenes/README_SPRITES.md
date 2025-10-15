# Sprite Assets - Placeholder Information

## Current Status
The game uses **programmatically generated colored rectangles** as sprite placeholders.

All towers and enemies create their own placeholder sprites in code:
```gdscript
func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
```

## What This Means
✅ **Game runs fine** - All entities are visible as colored rectangles
✅ **Gameplay works** - Towers shoot, enemies move, everything functions
❌ **Looks ugly** - Solid colors instead of proper sprites

## Current Placeholder Colors

### Towers
- **BaseTower**: Grey (32x32)
- **GuardTower**: Dark Green (32x32)
- **PropagandaSpeaker**: Red (32x32)
- **BureaucraticOffice**: Brown (32x32)
- **MissileStation**: Orange-Red (40x40)

### Enemies
- **BaseEnemy**: Blue (16x24)
- **Businessman**: Dark Blue (16x24)
- **Tourist**: Yellow (16x24)
- **Spy**: Dark Grey (16x24)
- **CEO**: Gold (24x32, scaled 1.5x)

### Projectiles
- **Bullet**: Yellow (4x4)
- **Missile**: Red (8x8)

## How to Replace with Real Sprites

### Step 1: Create/Obtain Sprites
See `../ASSET_REQUIREMENTS.md` for size requirements and style guide.

### Step 2: Add to Project
Place sprite files here:
```
assets/sprites/
├── towers/
│   ├── guard_tower.png
│   ├── propaganda_speaker.png
│   ├── bureaucratic_office.png
│   └── missile_station.png
├── enemies/
│   ├── businessman.png
│   ├── tourist.png
│   ├── spy.png
│   └── ceo.png
└── effects/
	├── explosion.png
	└── muzzle_flash.png
```

### Step 3: Load in Godot
1. Import sprites (Godot auto-imports PNG files)
2. Open scene file (e.g., `scenes/towers/GuardTower.tscn`)
3. Select the Sprite2D node
4. In Inspector, drag PNG to "Texture" property
5. Save scene

### Step 4: Remove Placeholder Code (Optional)
Once real sprites are in scenes, you can remove these lines from scripts:
```gdscript
# Remove this after adding real sprites:
if sprite:
	sprite.texture = create_placeholder_texture(Color.DARK_GREEN, Vector2(32, 32))
```

## Quick Sprite Creation Tips

### Using GIMP (Free)
1. Create 32x32 image
2. Draw tower/enemy
3. Export as PNG (with transparency)
4. Disable "Save background color"

### Using Aseprite (Paid, $20)
1. New Sprite: 32x32, RGBA
2. Draw pixel art
3. Export as PNG

### Using Online Tools
- [Piskel](https://www.piskelapp.com/) - Free pixel art editor
- [Pixilart](https://www.pixilart.com/) - Online pixel art tool

## Recommended: Use Asset Packs

Don't want to draw? Use these free asset packs:

### Kenney Assets (CC0 - Public Domain)
- [Tower Defense Pack](https://kenney.nl/assets/tower-defense-kit)
- [Top-Down Tanks](https://kenney.nl/assets/topdown-tanks-redux)
- Contains towers, enemies, effects, UI

### OpenGameArt.org
- Search "tower defense" for various styles
- Check license (most are CC-BY or CC0)

### Itch.io
- [Pixel Art Tower Defense Pack](https://itch.io/game-assets/free/tag-tower-defense)
- Many free and "pay what you want" options

## For Now: Colored Rectangles Work!

The game is fully playable with placeholders. Add sprites when you're ready for visual polish!

**Development priority**: Get gameplay working first, make it pretty later.
