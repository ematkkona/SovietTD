# Soviet Tower Defense - Godot 4.3 Project Structure

## Root Directory Structure
```
SovietTowerDefense/
├── project.godot
├── export_presets.cfg
├── README.md
├── .gitignore
└── [project folders below]
```

## Main Folder Organization

### 📁 **scenes/** - All game scenes
```
scenes/
├── main/
│   ├── Main.tscn                    # Main game scene
│   ├── MainMenu.tscn                # Start menu
│   ├── GameUI.tscn                  # HUD/UI overlay
│   └── PauseMenu.tscn               # Pause screen
├── levels/
│   ├── BaseLevel.tscn               # Level template
│   ├── Level01_Factory.tscn         # Potato factory level
│   ├── Level02_RedSquare.tscn       # Red Square level
│   └── TestLevel.tscn               # Development/testing
├── towers/
│   ├── BaseTower.tscn               # Tower base class
│   ├── GuardTower.tscn              # Basic shooting tower
│   ├── PropagandaSpeaker.tscn       # Slow/debuff tower
│   ├── BureaucraticOffice.tscn      # Area damage tower
│   └── MissileStation.tscn          # Heavy damage tower
├── enemies/
│   ├── BaseEnemy.tscn               # Enemy base class
│   ├── Businessman.tscn             # Basic capitalist
│   ├── Tourist.tscn                 # Fast, weak enemy
│   ├── Spy.tscn                     # Stealth enemy
│   └── CEO.tscn                     # Boss enemy
├── effects/
│   ├── Explosion.tscn               # Death/hit effects
│   ├── MuzzleFlash.tscn             # Tower shooting effect
│   ├── PropagandaWave.tscn          # Debuff visual
│   └── CoinPickup.tscn              # Resource collection
└── ui/
    ├── components/
    │   ├── TowerButton.tscn         # Tower selection button
    │   ├── UpgradePanel.tscn        # Tower upgrade UI
    │   ├── WaveProgress.tscn        # Wave countdown
    │   └── ResourceDisplay.tscn     # Rubles/lives counter
    └── dialogs/
        ├── VictoryScreen.tscn       # Level complete
        ├── DefeatScreen.tscn        # Game over
        └── SettingsMenu.tscn        # Options
```

### 📁 **scripts/** - All GDScript files
```
scripts/
├── autoloads/                       # Singleton scripts
│   ├── GameManager.gd              # Global game state
│   ├── AudioManager.gd             # Sound/music control
│   ├── SaveSystem.gd               # Save/load progress
│   └── EventBus.gd                 # Global event system
├── managers/
│   ├── WaveManager.gd              # Enemy wave spawning
│   ├── EconomyManager.gd           # Resources (rubles)
│   ├── TowerManager.gd             # Tower placement logic
│   └── LevelManager.gd             # Level progression
├── towers/
│   ├── BaseTower.gd                # Tower base class
│   ├── GuardTower.gd               # Basic tower logic
│   ├── PropagandaSpeaker.gd        # Debuff tower
│   ├── BureaucraticOffice.gd       # Area damage
│   └── MissileStation.gd           # Heavy tower
├── enemies/
│   ├── BaseEnemy.gd                # Enemy base class
│   ├── Businessman.gd              # Basic enemy
│   ├── Tourist.gd                  # Fast enemy
│   ├── Spy.gd                      # Stealth enemy
│   └── CEO.gd                      # Boss logic
├── ui/
│   ├── MainMenu.gd                 # Menu navigation
│   ├── GameUI.gd                   # HUD management
│   ├── TowerButton.gd              # Tower selection
│   └── UpgradePanel.gd             # Upgrade interface
└── utilities/
    ├── PathFollower.gd             # Enemy pathfinding
    ├── HealthSystem.gd             # Health/damage system
    ├── AnimationHelper.gd          # Animation utilities
    └── MobileInput.gd              # Touch input handler
```

### 📁 **assets/** - All game assets
```
assets/
├── sprites/
│   ├── towers/                     # Tower graphics
│   ├── enemies/                    # Enemy sprites
│   ├── ui/                         # Interface elements
│   ├── effects/                    # Particle/explosion sprites
│   ├── backgrounds/                # Level backgrounds
│   └── icons/                      # App icons, buttons
├── audio/
│   ├── music/
│   │   ├── main_theme.ogg          # Soviet march music
│   │   ├── victory_fanfare.ogg     # Level complete
│   │   └── menu_music.ogg          # Menu background
│   ├── sfx/
│   │   ├── tower_shoot.wav         # Weapon sounds
│   │   ├── enemy_death.wav         # Death sounds
│   │   ├── propaganda_voice.wav    # Comrade announcements
│   │   └── coin_collect.wav        # Resource pickup
│   └── voice/
│       ├── wave_incoming.ogg       # "Capitalists approaching!"
│       ├── tower_built.ogg         # "Excellent work, comrade!"
│       └── base_damaged.ogg        # "Our glorious motherland!"
├── fonts/
│   ├── soviet_propaganda.ttf       # Main game font
│   └── ui_text.ttf                 # Interface font
└── data/
    ├── levels/
    │   ├── level_01.json           # Level configuration
    │   └── wave_data.json          # Enemy wave definitions
    ├── towers/
    │   └── tower_stats.json        # Tower damage/cost data
    └── localization/
        ├── en.po                   # English text
        └── ru.po                   # Russian text (for authenticity!)
```

### 📁 **addons/** - Third-party plugins
```
addons/
├── phantom_camera/                 # Camera management
└── dialogic/                      # For comrade dialogue system
```

## Key Project Settings for Android

### Display Settings
- **Stretch Mode**: `canvas_items`
- **Stretch Aspect**: `keep`
- **Base Size**: `1920x1080` (scales well on mobile)

### Rendering Settings
- **Textures → Canvas Textures → Filter**: `Off` (pixel perfect)
- **2D → Use Pixel Snap**: `On`
- **Renderer**: `Mobile` (for Android optimization)

### Input Map
```
ui_touch           # Touch/tap
ui_drag           # Tower dragging
ui_pinch_zoom     # Zoom in/out
ui_pause          # Pause button
tower_1           # Quick tower selection 1-4
tower_2
tower_3  
tower_4
```

## Naming Conventions

### Files
- **Scenes**: PascalCase (e.g., `GuardTower.tscn`)
- **Scripts**: PascalCase (e.g., `WaveManager.gd`)
- **Assets**: snake_case (e.g., `guard_tower_sprite.png`)

### Code
- **Classes**: PascalCase (e.g., `class_name BaseTower`)
- **Variables/Functions**: snake_case (e.g., `var tower_damage`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `const MAX_HEALTH = 100`)
- **Signals**: snake_case with descriptive names (e.g., `signal enemy_defeated`)

## Git Setup

### .gitignore
```
# Godot files
.godot/
.import/

# Build files
builds/
*.tmp

# OS files
.DS_Store
Thumbs.db

# Development
*.log
debug/
```

## Development Phases

### Phase 1: Core Systems
1. Basic tower placement
2. Enemy pathfinding
3. Simple shooting mechanics
4. Resource system

### Phase 2: Content
1. Multiple tower types
2. Enemy variety
3. Wave management
4. UI polish

### Phase 3: Features
1. Upgrades system
2. Level progression
3. Save/load
4. Audio integration

### Phase 4: Polish
1. Particle effects
2. Animations
3. Mobile optimization
4. Localization

This structure will keep your project organized and scalable as you add the glorious features of socialist tower defense! 🚩
