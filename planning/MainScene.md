# Main Scene Setup - Soviet Tower Defense

## Main.tscn Scene Structure

```
Main (Node2D)
├── Background (CanvasLayer) [layer: -10]
│   └── BackgroundSprite (Sprite2D)
│       └── ParallaxBackground (ParallaxBackground) [optional for depth]
│
├── GameWorld (Node2D) [Main gameplay container]
│   ├── Level (Node2D) [Current level instance]
│   │   ├── TileMap (TileMap) [Grid for tower placement]
│   │   ├── PathContainer (Node2D)
│   │   │   └── EnemyPath (Path2D) [Enemy walking route]
│   │   │       └── PathFollow2D
│   │   ├── TowerContainer (Node2D) [All placed towers]
│   │   ├── EnemyContainer (Node2D) [All active enemies]
│   │   ├── ProjectileContainer (Node2D) [All projectiles]
│   │   └── EffectsContainer (Node2D) [Explosions, etc.]
│   │
│   ├── Camera (Camera2D)
│   │   └── CameraController (Node) [Mobile camera controls]
│   │
│   └── InputHandler (Node) [Touch/mouse input processing]
│
├── UI (CanvasLayer) [layer: 10]
│   ├── GameUI (Control)
│   │   ├── TopBar (HBoxContainer) [Resources, lives, wave info]
│   │   │   ├── ResourcesPanel (HBoxContainer)
│   │   │   │   ├── RublesIcon (TextureRect)
│   │   │   │   ├── RublesCount (Label)
│   │   │   │   ├── LivesIcon (TextureRect)
│   │   │   │   └── LivesCount (Label)
│   │   │   ├── WaveInfo (VBoxContainer)
│   │   │   │   ├── WaveLabel (Label) ["Волна 3/10"]
│   │   │   │   └── NextWaveTimer (Label) ["Next: 15s"]
│   │   │   └── MenuButton (Button) [Pause/Settings]
│   │   │
│   │   ├── SidePanel (VBoxContainer) [Tower selection]
│   │   │   ├── PanelBackground (NinePatchRect)
│   │   │   ├── TowerButtons (GridContainer)
│   │   │   │   ├── GuardTowerBtn (TowerButton)
│   │   │   │   ├── PropagandaBtn (TowerButton)
│   │   │   │   ├── BureaucracyBtn (TowerButton)
│   │   │   │   └── MissileBtn (TowerButton)
│   │   │   └── TowerInfo (VBoxContainer)
│   │   │       ├── TowerName (Label)
│   │   │       ├── TowerDescription (RichTextLabel)
│   │   │       └── TowerCost (Label)
│   │   │
│   │   └── BottomBar (HBoxContainer) [Action buttons]
│   │       ├── StartWaveBtn (Button) ["Send Next Wave!"]
│   │       ├── SpeedControls (HBoxContainer)
│   │       │   ├── Speed1x (Button)
│   │       │   ├── Speed2x (Button)
│   │       │   └── Speed4x (Button)
│   │       └── SpecialAbilities (HBoxContainer)
│   │           ├── PropagandaBoost (Button) ["INSPIRE COMRADES!"]
│   │           └── AirStrike (Button) ["CALL THE MIG!"]
│   │
│   └── Dialogs (Control) [Popups and overlays]
│       ├── TowerUpgradePanel (AcceptDialog)
│       ├── PauseMenu (AcceptDialog)
│       ├── VictoryScreen (AcceptDialog)
│       └── DefeatScreen (AcceptDialog)
│
├── AudioManager (Node2D) [Audio handling]
│   ├── MusicPlayer (AudioStreamPlayer)
│   ├── SFXPlayer (AudioStreamPlayer)
│   └── VoicePlayer (AudioStreamPlayer) [Comrade announcements]
│
└── Managers (Node) [Game logic singletons]
    ├── WaveManager (Node)
    ├── TowerManager (Node)
    ├── EconomyManager (Node)
    └── InputManager (Node) [Mobile input processing]
```

## Android-Specific Considerations

### 1. Canvas Layer Setup
```gdscript
# UI layer settings for Android
UI.layer = 10
UI.follow_viewport_enabled = false  # Keep UI fixed
Background.layer = -10

# Safe area handling for notched phones
func _ready():
    get_viewport().set_snap_2d_transforms_to_pixel(true)
    get_viewport().set_snap_2d_vertices_to_pixel(true)
    
    # Handle safe areas (notches, etc.)
    var safe_area = DisplayServer.get_display_safe_area()
    adjust_ui_for_safe_area(safe_area)
```

### 2. Camera Configuration
```gdscript
# Camera2D settings for mobile
Camera.enabled = true
Camera.current = true
Camera.zoom = Vector2(1.0, 1.0)  # Start zoomed appropriately
Camera.limit_smoothed = true

# Mobile camera bounds
Camera.limit_left = 0
Camera.limit_top = 0
Camera.limit_right = 1920  # Match your level width
Camera.limit_bottom = 1080 # Match your level height

# Smooth camera for mobile performance
Camera.position_smoothing_enabled = true
Camera.position_smoothing_speed = 5.0
```

### 3. Touch-Friendly UI Sizing
```gdscript
# Minimum touch target sizes (44pt rule)
const MIN_TOUCH_SIZE = Vector2(132, 132)  # 44dp at 3x density

# UI scaling for different screen densities
func setup_ui_scaling():
    var scale_factor = get_viewport().get_screen_transform().get_scale().x
    
    # Adjust UI elements for screen density
    for button in get_tree().get_nodes_in_group("ui_buttons"):
        button.custom_minimum_size = MIN_TOUCH_SIZE * scale_factor
```

## Scene Configuration Files

### Main.tscn Key Settings
```ini
[node name="Main" type="Node2D"]
script = ExtResource("path/to/Main.gd")

[node name="GameWorld" type="Node2D" parent="."]
z_index = 0

[node name="Camera" type="Camera2D" parent="GameWorld"]
zoom = Vector2(1, 1)
position_smoothing_enabled = true
position_smoothing_speed = 5.0

[node name="UI" type="CanvasLayer" parent="."]
layer = 10
follow_viewport_enabled = false

# TileMap for tower placement grid
[node name="TileMap" type="TileMap" parent="GameWorld/Level"]
tile_set = ExtResource("path/to/placement_tileset.tres")
format = 2
layer_0/tile_data = PackedInt32Array(...)  # Your grid data
```

### Mobile Input Handling
```gdscript
# InputHandler.gd - Touch input processing
extends Node

signal tower_placement_requested(tower_type: String, position: Vector2)
signal tower_selected(tower: Tower)
signal camera_pan_requested(delta: Vector2)
signal camera_zoom_requested(zoom_level: float)

var is_dragging_camera = false
var drag_start_position = Vector2.ZERO
var selected_tower_type = ""

func _input(event):
    if event is InputEventScreenTouch:
        handle_touch_input(event)
    elif event is InputEventScreenDrag:
        handle_drag_input(event)

func handle_touch_input(event: InputEventScreenTouch):
    if event.pressed:
        var world_pos = get_global_mouse_position()
        
        if selected_tower_type != "":
            # Try to place tower
            tower_placement_requested.emit(selected_tower_type, world_pos)
        else:
            # Select existing tower or start camera drag
            var clicked_tower = get_tower_at_position(world_pos)
            if clicked_tower:
                tower_selected.emit(clicked_tower)
            else:
                is_dragging_camera = true
                drag_start_position = event.position
```

### Resource Management for Mobile
```gdscript
# Memory optimization for Android
func _ready():
    # Optimize for mobile performance
    RenderingServer.camera_set_use_occlusion_culling(get_viewport().get_camera_3d().get_camera_rid(), true)
    
    # Preload critical resources
    preload_essential_assets()
    
    # Set up object pooling for performance
    setup_object_pools()

func preload_essential_assets():
    # Preload frequently used assets to avoid hitches
    var essential_assets = [
        "res://assets/sprites/towers/guard_tower.png",
        "res://assets/sprites/enemies/businessman.png",
        "res://assets/audio/sfx/tower_shoot.wav"
    ]
    
    for asset_path in essential_assets:
        load(asset_path)
```

## Level Integration System
```gdscript
# Main.gd - Level loading system
extends Node2D

@onready var level_container = $GameWorld/Level
@onready var camera = $GameWorld/Camera
@onready var ui = $UI/GameUI

var current_level_data: LevelData

func load_level(level_name: String):
    # Clear previous level
    for child in level_container.get_children():
        child.queue_free()
    
    # Load new level scene
    var level_scene = load("res://scenes/levels/" + level_name + ".tscn")
    var level_instance = level_scene.instantiate()
    level_container.add_child(level_instance)
    
    # Set camera bounds based on level size
    setup_camera_for_level(level_instance.get_level_bounds())
    
    # Initialize wave manager with level data
    WaveManager.setup_waves(level_instance.get_wave_data())

func setup_camera_for_level(bounds: Rect2):
    camera.limit_left = bounds.position.x
    camera.limit_top = bounds.position.y  
    camera.limit_right = bounds.position.x + bounds.size.x
    camera.limit_bottom = bounds.position.y + bounds.size.y
    
    # Center camera on level start
    camera.global_position = bounds.get_center()
```

## Performance Optimization Notes

### Mobile-Specific Optimizations:
1. **Object Pooling**: Reuse projectiles and effects
2. **LOD System**: Reduce detail for distant objects
3. **Batched Drawing**: Group similar sprites
4. **Audio Management**: Limit concurrent audio streams
5. **Memory Management**: Preload vs. dynamic loading balance

### Android Export Settings:
- **Architecture**: arm64-v8a (primary), armeabi-v7a (compatibility)
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 33+ (latest)
- **Permissions**: Only what you need
- **Screen Orientation**: Landscape (locked for TD games)

This scene structure gives you a solid, mobile-optimized foundation with clear separation of concerns. The camera system handles touch input smoothly, UI scales properly across devices, and the container system keeps everything organized for your glorious Soviet tower defense! 🚩

Ready for the basic scripts for the core game manager next?
