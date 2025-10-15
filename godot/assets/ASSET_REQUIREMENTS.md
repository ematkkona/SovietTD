# Soviet Tower Defense - Asset Requirements

## Overview
This document lists all assets needed for the game. Use this as a checklist when creating or sourcing assets.

---

## 🎨 SPRITES & GRAPHICS

### Towers (5 sprites needed)
| Asset Name | Size | Description | Priority |
|------------|------|-------------|----------|
| `guard_tower.png` | 32x32 | Basic defense tower, military green | HIGH |
| `propaganda_speaker.png` | 32x32 | Red loudspeaker/horn tower | HIGH |
| `bureaucratic_office.png` | 32x32 | Brown/grey office building tower | MEDIUM |
| `missile_station.png` | 40x40 | Orange-red missile launcher | MEDIUM |
| `tower_base.png` | 32x32 | Generic tower placeholder | LOW |

**Style Notes**: Pixel art or simple 2D sprites, Soviet aesthetic (red stars, hammers & sickles optional)

---

### Enemies (4 sprites needed)
| Asset Name | Size | Description | Priority |
|------------|------|-------------|----------|
| `businessman.png` | 16x24 | Blue suit, briefcase, capitalist look | HIGH |
| `tourist.png` | 16x24 | Yellow/bright colors, camera, casual | HIGH |
| `spy.png` | 16x24 | Dark grey/black, sneaky appearance | MEDIUM |
| `ceo.png` | 24x32 | Gold/expensive suit, larger, boss-like | MEDIUM |

**Animation**: Static sprites are fine, but 2-4 frame walk cycles would be nice

---

### Effects (4 sprites needed)
| Asset Name | Size | Description | Priority |
|------------|------|-------------|----------|
| `explosion.png` | 32x32 | Enemy death explosion effect | HIGH |
| `muzzle_flash.png` | 16x16 | Tower shooting flash | MEDIUM |
| `propaganda_wave.png` | 48x48 | Red circular wave effect | LOW |
| `coin_pickup.png` | 16x16 | Ruble symbol or coin | LOW |

**Animation**: 4-8 frame sprite sheets recommended

---

### UI Elements (10+ icons needed)
| Asset Name | Size | Description | Priority |
|------------|------|-------------|----------|
| `icon_rubles.png` | 16x16 | Ruble currency symbol | HIGH |
| `icon_heart.png` | 16x16 | Life/health icon | HIGH |
| `icon_wave.png` | 16x16 | Wave indicator | MEDIUM |
| `icon_upgrade.png` | 16x16 | Upgrade arrow | MEDIUM |
| `icon_sell.png` | 16x16 | Sell/trash icon | MEDIUM |
| `button_play.png` | 128x64 | Main menu play button | HIGH |
| `button_settings.png` | 128x64 | Settings button | LOW |
| `button_quit.png` | 128x64 | Quit button | LOW |
| `panel_bg.png` | 9-patch | UI panel background | MEDIUM |
| `tower_range_circle.png` | 256x256 | Semi-transparent range indicator | LOW |

---

### Backgrounds (3 images needed)
| Asset Name | Size | Description | Priority |
|------------|------|-------------|----------|
| `bg_factory.png` | 1920x1080 | Industrial factory setting | MEDIUM |
| `bg_red_square.png` | 1920x1080 | Red Square Moscow setting | LOW |
| `bg_test.png` | 1920x1080 | Simple grid or solid color | HIGH |

**Note**: Can be parallax layers or single images

---

## 🔊 AUDIO

### Music (3 tracks needed)
| Asset Name | Duration | Description | Priority |
|------------|----------|-------------|----------|
| `main_theme.ogg` | 2-3 min loop | Soviet march music, heroic | HIGH |
| `menu_music.ogg` | 1-2 min loop | Lighter, menu-appropriate | MEDIUM |
| `victory_fanfare.ogg` | 10-15 sec | Triumphant victory jingle | LOW |

**Format**: OGG Vorbis (loopable)
**Style**: Soviet/Russian inspired, orchestral or chiptune

---

### Sound Effects (15+ sounds needed)

#### Combat Sounds
| Asset Name | Description | Priority |
|------------|-------------|----------|
| `tower_shoot.wav` | Generic gunshot/projectile fire | HIGH |
| `missile_launch.wav` | Rocket/missile launch whoosh | MEDIUM |
| `enemy_death.wav` | Enemy defeat sound | HIGH |
| `explosion.wav` | General explosion | MEDIUM |

#### Tower/Building Sounds
| Asset Name | Description | Priority |
|------------|-------------|----------|
| `tower_place.wav` | Tower construction sound | HIGH |
| `tower_upgrade.wav` | Upgrade ding/chime | MEDIUM |
| `tower_sell.wav` | Sell/refund sound | LOW |

#### UI Sounds
| Asset Name | Description | Priority |
|------------|-------------|----------|
| `button_click.wav` | Generic button press | HIGH |
| `coin_collect.wav` | Ruble/money earned | MEDIUM |
| `wave_start.wav` | Wave begin alert | HIGH |
| `wave_complete.wav` | Wave victory sound | MEDIUM |
| `game_over.wav` | Defeat sound | MEDIUM |

#### Propaganda Speaker Effects
| Asset Name | Description | Priority |
|------------|-------------|----------|
| `propaganda_activate.wav` | Speaker activation | LOW |
| `propaganda_loop.wav` | Looping distortion/slow effect | LOW |

**Format**: WAV (16-bit, 44.1kHz) or OGG

---

### Voice Lines (Optional, 8+ clips)
| Asset Name | Description | Priority |
|------------|-------------|----------|
| `wave_incoming.ogg` | "Capitalists approaching!" | LOW |
| `tower_built.ogg` | "Excellent work, comrade!" | LOW |
| `base_damaged.ogg` | "Defend the motherland!" | LOW |
| `low_funds.ogg` | "We need more rubles!" | LOW |
| `victory.ogg` | "Victory for the people!" | LOW |
| `defeat.ogg` | "We have failed the motherland..." | LOW |

**Format**: OGG Vorbis
**Style**: Over-the-top Soviet propaganda voice (English or Russian)

---

## 🔤 FONTS (2 fonts needed)

| Asset Name | Description | Priority | License |
|------------|-------------|----------|---------|
| `soviet_propaganda.ttf` | Bold, communist poster style | HIGH | OFL/Free |
| `ui_text.ttf` | Clean, readable UI font | HIGH | OFL/Free |

**Recommendations**:
- [Bebas Neue](https://fonts.google.com/specimen/Bebas+Neue) - Bold propaganda style
- [Roboto](https://fonts.google.com/specimen/Roboto) - Clean UI text

---

## 📊 DATA FILES (JSON configurations)

### Already in Scripts (Hardcoded)
- ✅ Tower stats - In tower scripts
- ✅ Enemy stats - In enemy scripts
- ✅ Wave data - In WaveManager.gd

### Could Be Externalized (Optional)
- `tower_stats.json` - Tower damage, cost, range data
- `wave_data.json` - Wave configurations per level
- `level_config.json` - Level-specific settings

---

## 🎯 PLACEHOLDER ASSETS (Temporary)

The game currently uses **programmatically generated colored rectangles** for all sprites:
- Towers: Solid color squares (32x32 or 40x40)
- Enemies: Solid color rectangles (16x24 or 24x32)
- Effects: Not visible (need sprites)
- UI: Godot default theme

**These work but are ugly!** Replace with proper assets when available.

---

## 📦 ASSET SOURCES (Where to Find Free Assets)

### Sprites
- [OpenGameArt.org](https://opengameart.org/) - Free game assets
- [itch.io](https://itch.io/game-assets/free) - Free & paid asset packs
- [Kenney.nl](https://kenney.nl/assets) - Free game assets, many tower defense packs

### Audio
- [freesound.org](https://freesound.org/) - Free sound effects (CC licenses)
- [incompetech.com](https://incompetech.com/) - Royalty-free music by Kevin MacLeod
- [OpenGameArt.org/audio](https://opengameart.org/art-search-advanced?keys=&field_art_type_tid%5B%5D=12) - Free game audio

### Fonts
- [Google Fonts](https://fonts.google.com/) - Free, open source fonts
- [DaFont](https://www.dafont.com/) - Free fonts (check licenses)

---

## 🚀 PRIORITY IMPLEMENTATION ORDER

### Phase 1: Core Gameplay (Must Have)
1. ✅ Placeholder sprites (colored rectangles) - DONE
2. Tower icons for UI buttons
3. Enemy sprites (basic 4 types)
4. Basic sound effects (shoot, death, click)

### Phase 2: Polish (Should Have)
5. Tower sprites (4 types)
6. Background music (main theme)
7. UI panel graphics
8. Explosion/effect sprites

### Phase 3: Juice (Nice to Have)
9. Animated sprites (walk cycles, shooting)
10. Voice lines
11. Multiple music tracks
12. Particle effects

---

## 📝 NOTES

- All sprite sizes are recommendations, adjust based on your art style
- Audio should be normalized to prevent volume spikes
- Consider creating a style guide document for consistent art direction
- Placeholder assets allow development to continue while art is being created
- Use version control for binary assets (Git LFS or separate asset repo)

**Current Status**: Game runs with programmatic placeholders. All gameplay functional, awaiting art assets.
