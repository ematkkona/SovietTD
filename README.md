# 🚩 Soviet Tower Defense

**Version 0.2 (Alpha)**

A Soviet-themed tower defense game built with Godot 4.5, where you defend the glorious motherland against waves of capitalist invaders!

![Demo Screenshot 1](docs/screenshots/demo.png)
![Demo Screenshot 2](docs/screenshots/demo2.png)

## 🎮 Game Features

### Tower Types
- **Guard Tower** - Basic projectile tower with reliable damage
- **Propaganda Speaker** - Slows enemies with ideological broadcasts
- **Bureaucratic Office** - Deals continuous area damage to all nearby enemies
- **Missile Station** - Heavy damage, long range, slow fire rate

### Enemies
- **Businessman** - Basic capitalist unit
- **Tourist** - Fast but weak
- **Oligarch** - Wealthy and resilient
- **CEO Boss** - Powerful boss enemy (500 HP!)

### Game Mechanics
- **6 Progressive Waves** - Increasing difficulty with mixed enemy types
- **Economy System** - Earn rubles by eliminating enemies, spend to build towers
- **Lives System** - Start with 20 lives, lose one per enemy that reaches the end
- **Manual Wave Start** - Strategic control over when to face the next challenge
- **Tower Placement Validation** - Smart placement system prevents overlaps

## 🛠️ Technical Details

### Built With
- **Godot Engine**: 4.5
- **Language**: GDScript
- **Target Platform**: Android (optimized for mobile)
- **Rendering**: Mobile renderer with pixel-perfect settings

### Project Structure
```
scenes/
├── main/          # Main game scene, menu
├── towers/        # 4 tower type scenes
├── enemies/       # 4 enemy type scenes
├── projectiles/   # Bullet/missile projectiles
└── ui/            # Game UI and HUD

scripts/
├── autoloads/     # Global managers (GameManager, EventBus, etc.)
├── managers/      # Game systems (WaveManager, EconomyManager, etc.)
├── towers/        # Tower behavior scripts
├── enemies/       # Enemy AI and pathfinding
└── projectiles/   # Projectile movement and collision

addons/
├── phantom_camera/    # Camera management
└── dialogic/          # Dialogue system (for future story mode)
```

### Architecture Highlights
- **Singleton Pattern** - Global managers via Godot's autoload system
- **EventBus Pattern** - Decoupled communication between systems
- **Scene Inheritance** - BaseTower/BaseEnemy classes for shared functionality
- **Signal-Based Design** - Event-driven tower targeting and wave management

## 🚀 Getting Started

### Prerequisites
- Godot 4.5 or later
- Android device/emulator (optional, for mobile testing)

### Running the Game
1. Clone the repository
2. Open the project in Godot Engine 4.5+
3. Press **F5** to run the game
4. Click tower buttons to select, click on map to place
5. Click **START WAVE** to begin

### Controls
- **Tap/Click** - Select tower type from UI
- **Tap on Map** - Show placement preview
- **Tap Again** - Lock position
- **Hold (0.6s)** - Confirm and build tower (with progress circle)
- **Release Early** - Cancel placement
- **Drag** - Reposition preview before locking
- **UI Buttons** - Tower selection, wave start, game speed control

## 🎯 How to Play

1. **Select Tower**: Tap a tower button in the UI (costs rubles)
2. **Position Tower**: Tap on the map to show placement preview (green = valid, red = invalid)
3. **Lock Position**: Tap again to lock the tower location
4. **Confirm Build**: Hold down for 0.6 seconds - watch the progress circle fill up!
5. **Start Wave**: Tap the START WAVE button when ready
6. **Defend**: Towers automatically target and shoot enemies
7. **Earn Money**: Gain rubles for each enemy eliminated
8. **Survive**: Don't let too many enemies reach the end (you have 20 lives)
9. **Progress**: Complete all 6 waves to achieve victory!

### Strategy Tips
- **Propaganda Speakers** slow enemies, giving other towers more time
- **Bureaucratic Offices** excel against grouped enemies
- **Missile Stations** are expensive but essential for high-HP bosses
- **Guard Towers** provide cost-effective coverage for early waves

## 📊 Game Balance

### Tower Stats
| Tower | Cost | Damage | Range | Special |
|-------|------|--------|-------|---------|
| Guard Tower | 100₽ | 25 | 200 | Reliable DPS |
| Propaganda Speaker | 150₽ | 0 | 180 | 50% slow for 3s |
| Bureaucratic Office | 200₽ | 15/tick | 150 | Hits all in range |
| Missile Station | 300₽ | 100 | 250 | Long range, slow |

### Wave Progression
1. **Wave 1**: 5 Businessmen (tutorial wave)
2. **Wave 2**: 8 Businessmen (faster spawns)
3. **Wave 3**: 5 Businessmen + 3 Tourists (mixed)
4. **Wave 4**: 10 Tourists (speed test)
5. **Wave 5**: 6 Businessmen + 6 Tourists (12 enemies!)
6. **Wave 6**: 1 CEO Boss (500 HP challenge)

## 🎨 Visual Style

**Custom Pixel Art Sprites** created with procedural generation:

### Towers
- **Guard Tower** (32x32) - Soviet watchtower with brown wood, red roof, and red star
- **Propaganda Speaker** (32x32) - Red loudspeaker on gray pole with yellow sound waves
- **Bureaucratic Office** (32x32) - Gray building with dark windows and flying paperwork
- **Missile Station** (40x40) - Red rocket on launch platform with yellow nose cone

### Enemies
- **Businessman** (16x24) - Dark blue suit, red tie, black hat, briefcase with $ sign
- **Tourist** (16x24) - Yellow sun hat, bright Hawaiian shirt, camera, white sneakers
- **CEO Boss** (24x32) - Gold crown, pinstripe suit, gold tie, cigar with smoke

### Still Placeholder
- Projectiles: Simple colored dots (yellow bullets, red missiles)
- UI: Functional buttons with text labels
- Effects: Basic visual feedback

*Future: Animated sprites, particle effects, and polished UI*

## 🔧 Development

### Current Status
✅ Core tower defense mechanics
✅ All 4 tower types functional
✅ 6-wave progression system
✅ Economy and lives systems
✅ Tower placement validation
✅ Enemy pathfinding
✅ Collision detection
✅ Wave completion detection
✅ **Pixel art sprites for towers and enemies**

### Planned Features
- [x] Visual assets (basic pixel art sprites)
- [x] Mobile touch controls (hold-to-confirm placement) ✨ **v0.2**
- [ ] Sprite animations (attack, walk cycles)
- [ ] Audio (music, sound effects, voice lines)
- [ ] Tower upgrade system
- [ ] Multiple levels
- [ ] Save/load system
- [ ] Settings menu
- [ ] Particle effects
- [ ] Victory/defeat screens
- [ ] Localization (Russian translation)

## 📋 Changelog

### Version 0.2 (Alpha) - 2025-10-22
**Mobile-First Touch Controls Update**

**New Features:**
- ✨ **Intuitive Tower Placement**: Preview appears at first tap location, no more dragging from corner
- ⏱️ **Hold-to-Confirm Mechanic**: Hold for 0.6s with visual progress circle to confirm tower placement
- 🎨 **Visual Feedback Effects**:
  - Circular progress indicator that fills during hold
  - Tower pulsing and range brightness effects while holding
  - Satisfying burst animation on successful placement
- 🎯 **Smart Cancellation**: Auto-cancels if finger drags away or releases early

**Bug Fixes & Improvements:**
- 🐛 Fixed duplicate resource state management (GameManager/EconomyManager desync)
- 🐛 Fixed memory leaks in PropagandaSpeaker and BureaucraticOffice visual effects
- 🐛 Fixed null reference bug in Bullet explosion spawning
- 🐛 Fixed tower preview memory leak using immediate cleanup
- 🐛 Resolved duplicate GameUI.gd files
- 🔧 Centralized all cross-system signals through EventBus
- 🧹 Added proper cleanup in BaseEnemy._exit_tree()
- 📝 Renamed 'urange' to 'tower_range' for better code clarity

**Code Quality:**
- Major architecture refactoring for consistency
- Improved signal architecture adherence to EventBus pattern
- Better memory management throughout tower and enemy systems

### Version 0.1 (Alpha) - 2025-10-18
**Initial Release**
- Core tower defense mechanics
- 4 tower types, 4 enemy types
- 6-wave progression system
- Basic pixel art sprites
- Economy and lives systems
- Path-based enemy movement

## 📝 License

This project is open source and available for educational purposes.

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome!

---

*Defend the motherland, comrade! 🚩*
