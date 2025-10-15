# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Soviet Tower Defense (SovietTD)** - A Godot 4.5 tower defense game with a Soviet theme, targeting Android mobile platforms. Players defend against capitalist enemies using various Soviet-themed towers.

## Development Commands

### Running the Project
- Open `godot/project.godot` in Godot 4.5 editor
- Main scene: `res://scenes/main/Main.tscn`
- The project is configured for mobile rendering (1920x1080, canvas_items stretch mode)

### Project Structure
```
tddSOVIET/
├── godot/                    # Main Godot project directory
│   ├── project.godot         # Project configuration
│   ├── scenes/              # All .tscn scene files
│   ├── scripts/             # All .gd script files
│   └── addons/              # Third-party plugins (phantom_camera, dialogic)
├── planning/                 # Design documents and project planning
├── GeneralProjectStructure.md  # Detailed architecture documentation
└── CLAUDE.md                # This file
```

## Architecture

### Autoload Singletons (Global Systems)
The project uses Godot's autoload system for core game systems. These are globally accessible and initialized in this order:

1. **PhantomCameraManager** - Third-party camera management plugin
2. **Dialogic** - Third-party dialogue system plugin
3. **GameManager** (`scripts/autoloads/GameManager.gd`) - Global game state
4. **EventBus** (`scripts/autoloads/EventBus.gd`) - Signal-based decoupled communication system
5. **AudioManager** (`scripts/autoloads/AudioManager.gd`) - Sound and music control
6. **WaveManager** (`scripts/managers/WaveManager.gd`) - Enemy wave spawning system
7. **EconomyManager** (`scripts/managers/EconomyManager.gd`) - Resources (rubles) and lives management
8. **LevelManager** (`scripts/managers/LevelManager.gd`) - Level progression
9. **TowerManager** (`scripts/managers/TowerManager.gd`) - Tower placement logic
10. **SaveSystem** (`scripts/autoloads/SaveSystem.gd`) - Save/load progress

### Core Game Loop Architecture

**Wave System:**
- `WaveManager` loads wave configurations from hardcoded data (future: JSON files in `assets/data/levels/`)
- Wave configuration includes enemy types, counts, and spawn intervals
- Enemies are spawned sequentially with configurable delays
- Wave completion tracked by monitoring remaining enemies via signal connections

**Enemy System:**
- All enemies extend `BaseEnemy` class (`scripts/enemies/BaseEnemy.gd`)
- Enemies use Path2D/PathFollow2D for movement along predefined routes
- Health, speed, and reward values are exported properties
- Slow effects are tracked as array of dictionaries with duration timers
- Enemies emit `enemy_died` and `enemy_reached_end` signals

**Tower System:**
- All towers extend `BaseTower` class (`scripts/towers/BaseTower.gd`)
- Towers use Area2D for range detection (collision_mask = 2 for enemy layer)
- Targeting strategy: "First" (most progress along path)
- Projectiles spawned from `scenes/projectiles/Bullet.tscn`
- Upgrades handled through `upgrade_tower()` method with cost scaling

**Economy System:**
- Starting resources: 600 rubles, 20 lives
- Kill rewards defined per enemy type in `EconomyManager`
- Economy signals: `rubles_changed`, `lives_changed`, `not_enough_rubles`

**Event-Driven Communication:**
Use `EventBus` for cross-system communication instead of direct references:
- Tower events: `tower_placed`, `tower_sold`, `tower_upgraded`
- Enemy events: `enemy_spawned`, `enemy_killed`, `enemy_reached_base`
- Game events: `wave_started`, `wave_completed`, `level_completed`, `game_paused`
- UI events: `ui_tower_selected`, `ui_speed_changed`, `ui_special_ability_used`

### Scene Organization

**Main Scenes:**
- `scenes/main/Main.tscn` - Primary game scene
- `scenes/main/MainMenu.tscn` - Start menu (script: `scenes/main/MainMenu.gd`)
- `scenes/effects/GameUI.tscn` - HUD overlay (script: `scenes/ui/GameUI.gd`)

**Levels:**
- `scenes/levels/BaseLevel.tscn` - Level template
- `scenes/levels/TestLevel.tscn` - Development/testing level
- Each level contains Path2D nodes for enemy pathfinding

**Entities:**
- Tower scenes: `scenes/towers/` (PropagandaSpeaker.tscn, etc.)
- Enemy scenes: `scenes/enemies/` (Businessman.tscn, Tourist.tscn, CEO.tscn, Spy.tscn)
- UI components: `scenes/ui/components/` and `scenes/ui/dialogs/`

### Naming Conventions

**Files:**
- Scenes: PascalCase (e.g., `GuardTower.tscn`)
- Scripts: PascalCase (e.g., `WaveManager.gd`)
- Assets: snake_case (e.g., `guard_tower_sprite.png`)

**Code:**
- Classes: PascalCase with `class_name` (e.g., `class_name BaseTower`)
- Variables/Functions: snake_case (e.g., `var tower_damage`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `const MAX_HEALTH = 100`)
- Signals: snake_case (e.g., `signal enemy_defeated`)

### Collision Layers
- Layer 1: Default
- Layer 2: Enemies (used for tower range detection)
- Enemies: `collision_layer = 2`, `collision_mask = 0`
- Tower range areas: `collision_layer = 0`, `collision_mask = 2`

### Rendering Settings
- Renderer: `mobile` (optimized for Android)
- Texture filter: `0` (pixel perfect, no filtering)
- 2D pixel snap: enabled for both transforms and vertices
- Viewport: 1920x1080 fullscreen (mode=3), non-resizable

### Key Implementation Patterns

**Pathfinding:**
Enemies don't pathfind dynamically. Instead:
1. Level designers create Path2D nodes in level scenes
2. WaveManager finds Path2D in level using `find_children("*", "Path2D")`
3. Enemies instantiate PathFollow2D as child of Path2D
4. Enemy position updated each frame: `global_position = path_follow.global_position`

**Targeting Priority:**
Towers use `get_path_progress()` to prioritize enemies closest to the base:
```gdscript
var progress = enemy.get_path_progress()  # Returns PathFollow2D.progress_ratio
```

**Timer-based Fire Rate:**
Towers use one-shot Timer nodes that restart after each shot rather than continuous cooldown tracking.

## Common Development Tasks

When adding new enemy types:
1. Create scene in `scenes/enemies/` extending `BaseEnemy.tscn`
2. Create script extending `BaseEnemy.gd` in `scripts/enemies/`
3. Add reward entry in `EconomyManager.get_kill_reward()`
4. Add to wave configuration in `WaveManager.load_wave_configuration()`

When adding new tower types:
1. Create scene in `scenes/towers/`
2. Create script extending `BaseTower.gd` in `scripts/towers/`
3. Override `create_projectile()` if using custom projectile behavior
4. Update TowerManager for placement UI integration

When working with signals:
- Always connect through EventBus for cross-system events
- Use direct connections only for parent-child node relationships
- Check EventBus.gd for available signals before creating new ones

## Dependencies

**Third-party Addons:**
- `phantom_camera` - Camera management system (res://addons/phantom_camera/)
- `dialogic` - Dialogue and narrative system (res://addons/dialogic/)

Both plugins are enabled in project settings and have autoloaded managers.
