# Soviet Tower Defense - Asset Production Roadmap

## 🎯 Overview

This roadmap outlines a systematic, phased approach to replacing placeholder assets with final production-quality assets. Each phase is designed to maximize perceived quality improvement while minimizing time investment.

**Guiding Principles:**
- **Impact First**: Focus on assets players see/hear most frequently
- **Audio Before Visuals**: Sound has higher impact/effort ratio
- **Iterative Refinement**: Good enough now > Perfect later
- **Playtest Between Phases**: Validate improvements before moving on

---

## 📊 Phase Summary

| Phase | Focus | Duration Est. | Impact | Status |
|-------|-------|---------------|--------|--------|
| **0** | Project Setup | 1-2 hours | Foundation | ⬜ Not Started |
| **1** | Core Audio (SFX) | 3-5 days | ⭐⭐⭐⭐⭐ | ⬜ Not Started |
| **2** | Background Music | 2-3 days | ⭐⭐⭐⭐ | ⬜ Not Started |
| **3** | Enemy Sprites | 4-7 days | ⭐⭐⭐⭐⭐ | ⬜ Not Started |
| **4** | Tower Sprites | 3-5 days | ⭐⭐⭐⭐ | ⬜ Not Started |
| **5** | UI Polish | 2-4 days | ⭐⭐⭐ | ⬜ Not Started |
| **6** | Effects & VFX | 2-3 days | ⭐⭐⭐ | ⬜ Not Started |
| **7** | Voice Lines | 1-2 days | ⭐⭐⭐ | ⬜ Not Started |
| **8** | Backgrounds | 3-5 days | ⭐⭐ | ⬜ Not Started |
| **9** | Final Polish | Ongoing | ⭐⭐ | ⬜ Not Started |

**Total Estimated Time**: 3-5 weeks part-time (assuming ~2 hours/day)

---

## 🚀 PHASE 0: Project Setup (1-2 hours)

**Goal**: Prepare tools and workspace for efficient asset creation.

### Tasks

#### Audio Production Setup
- [ ] Install **Audacity** (free audio editor)
  - Download: https://www.audacityteam.org/
  - Configure export presets (OGG, WAV 44.1kHz)
- [ ] Install **LMMS** or **BeepBox** (music creation)
  - LMMS: https://lmms.io/ (desktop, more powerful)
  - BeepBox: https://beepbox.co/ (web-based, simpler)
- [ ] Bookmark SFX tools:
  - SFXR: http://www.drpetter.se/project_sfxr.html
  - ChipTone: https://sfbgames.itch.io/chiptone
- [ ] Create microphone test recording (check audio quality)

#### Asset Organization
- [ ] Create working directories:
  ```
  ~/SovietTD_Assets/
  ├── audio_raw/          # Unprocessed recordings
  ├── audio_export/       # Final OGG/WAV files
  ├── sprites_wip/        # In-progress sprite work
  ├── sprites_export/     # Final PNG files
  └── references/         # Inspiration images
  ```
- [ ] Copy demo.png and demo2.png to references folder
- [ ] Create color palette file (extract colors from demos)

#### Reference Gathering
- [ ] Search OpenGameArt for Soviet/military pixel art (1 hour max)
- [ ] Bookmark 3-5 reference images per category (enemies, towers, backgrounds)
- [ ] Create inspiration board (Pinterest or local folder)

**Deliverable**: Functional workspace with tools installed and references organized.

---

## 🔊 PHASE 1: Core Sound Effects (3-5 days) ⭐ HIGHEST PRIORITY

**Goal**: Add essential combat and UI sounds. This phase has the biggest impact/effort ratio.

**Why First?**: Sound transforms game feel immediately. Players will tolerate simple graphics far longer than silent gameplay.

### Part A: Combat Sounds (Day 1-2)

**Essential 8 Sounds:**

1. **tower_shoot_rifle.wav** (Guard Tower)
   - Tool: SFXR or ChipTone
   - Reference: Short "pew" or "crack" gunshot
   - Length: 0.1-0.2 seconds
   - Volume: -6dB normalized

2. **tower_shoot_propaganda.wav** (Propaganda Speaker)
   - Tool: Audacity + voice recording
   - Method: Say "SHHHHH" into mic, add echo/reverb
   - Length: 0.3-0.5 seconds
   - Effect: Sounds like speaker activation

3. **tower_shoot_missile.wav** (Missile Station)
   - Tool: ChipTone
   - Reference: Upward pitch sweep + whoosh
   - Length: 0.4-0.6 seconds
   - Effect: Rocket launch sound

4. **tower_shoot_bureaucracy.wav** (Bureaucratic Office)
   - Tool: Audacity + real sounds
   - Method: Record paper shuffle + rubber stamp "thunk"
   - Length: 0.2-0.3 seconds
   - Quirky factor: High (this is a joke tower)

5. **enemy_death.wav**
   - Tool: Voice recording + pitch shift
   - Method: Record "ugh!" or "argh!", pitch down slightly
   - Length: 0.3-0.5 seconds
   - Variation: Create 2-3 variants, randomize in code

6. **explosion_small.wav**
   - Tool: SFXR (explosion preset)
   - Reference: Bullet impact, not massive
   - Length: 0.2-0.4 seconds

7. **explosion_large.wav** (Missile explosions)
   - Tool: SFXR (explosion preset, lower pitch)
   - Reference: Bigger boom than small
   - Length: 0.5-0.8 seconds

8. **enemy_hit.wav** (Damage taken, optional)
   - Tool: ChipTone
   - Reference: Quick "thud" or hurt sound
   - Length: 0.1 seconds

**Recording Tips:**
- Use "Generate > Noise" in Audacity for static/whoosh bases
- Layer 2-3 sounds for richer effects (e.g., missile = whoosh + low rumble)
- Always normalize to -6dB to prevent clipping
- Export as **WAV 16-bit 44.1kHz** first, then convert to OGG if needed

**Integration Checkpoint:**
- [ ] Place files in `assets/audio/sfx/`
- [ ] Launch game, verify sounds play during combat
- [ ] Adjust volumes if needed (edit AudioManager.gd constants)

### Part B: UI Sounds (Day 3)

**Essential 6 Sounds:**

1. **button_click.wav**
   - Tool: ChipTone or tap on table
   - Length: 0.05-0.1 seconds
   - Should be subtle, not annoying

2. **button_hover.wav** (optional but nice)
   - Same as click but quieter (-10dB)
   - Super short (0.03 seconds)

3. **tower_place.wav**
   - Tool: Foley (drop book on table) + pitch shift up
   - Length: 0.3-0.5 seconds
   - Effect: Satisfying "construction complete" feel

4. **tower_upgrade.wav**
   - Tool: ChipTone
   - Reference: Upward arpeggio or power-up sound
   - Length: 0.4-0.6 seconds
   - Should feel rewarding

5. **coins_collect.wav**
   - Tool: ChipTone (bell/chime preset)
   - Reference: Cash register "cha-ching"
   - Length: 0.3-0.5 seconds
   - Plays when enemy dies (reward feedback)

6. **insufficient_funds.wav**
   - Tool: ChipTone
   - Reference: Error beep, downward tone
   - Length: 0.2-0.3 seconds

**Integration Checkpoint:**
- [ ] Connect to UI buttons (TowerButton.gd, GameUI.gd)
- [ ] Test clicking around, ensure no audio spam
- [ ] Verify coin sound triggers on enemy death

### Part C: Wave/Game State Sounds (Day 4)

**Essential 4 Sounds:**

1. **wave_start.wav**
   - Tool: SFXR or air horn recording
   - Reference: Alert siren or horn blast
   - Length: 1-2 seconds
   - Should be attention-grabbing

2. **wave_complete.wav**
   - Tool: ChipTone
   - Reference: Victory jingle (3-4 note melody)
   - Length: 1-1.5 seconds
   - Should feel satisfying

3. **game_over.wav**
   - Tool: ChipTone
   - Reference: Sad descending notes
   - Length: 2-3 seconds
   - Somber but not depressing

4. **warning_alert.wav** (base being hit)
   - Tool: SFXR
   - Reference: Quick danger beep
   - Length: 0.3-0.5 seconds

**Integration Checkpoint:**
- [ ] Connect to WaveManager signals
- [ ] Connect to GameManager state changes
- [ ] Playtest full wave, ensure audio cues feel right

### Phase 1 Acceptance Criteria ✅

- [ ] All 18 sound effects created and exported
- [ ] Files in correct directories
- [ ] Game plays sounds during normal gameplay
- [ ] No audio clipping or distortion
- [ ] Volume levels balanced (no single sound dominates)
- [ ] **Playtest feels 3x better than silent version**

**Deliverable**: Fully functional audio-enhanced gameplay loop.

---

## 🎵 PHASE 2: Background Music (2-3 days)

**Goal**: Add looping music tracks for menu and gameplay.

**Why Second?**: Music is high-impact but requires more effort than SFX. With SFX done, music completes the audio experience.

### Part A: Research & Licensing (Day 1, ~2 hours)

**Option 1: SID Music Conversion** (Your idea, BEST for authenticity)

**Target Songs** (Public domain Soviet songs):
- "Katyusha" - Upbeat, march-like
- "Polyushka Polye" - Heroic, intense
- "Kalinka" - Energetic, folk-inspired
- "The Internationale" - Anthem (for victory/menu)

**C64 SID Sources:**
- HVSC (High Voltage SID Collection): https://www.hvsc.c64.org/
- Remix64: https://remix.kwed.org/
- Search: "Kalinka SID" or "Soviet march SID"

**Conversion Process:**
1. Download .sid file
2. Use **SIDPLAY** or **SIDBlaster** to convert to WAV
3. Import WAV into Audacity
4. Add light reverb/EQ if needed
5. Create loop point (fade or seamless edit)
6. Export as OGG Vorbis (quality: 5-6, ~128kbps)

**Licensing Check:**
- SID tunes: Check credits (most are derivative works, public domain)
- Soviet songs: Pre-1928 = public domain, post-1928 = check
- Safe bet: Focus on pre-WWII folk songs

**Option 2: Use Royalty-Free Tracks** (Backup plan)

**Sources:**
- Incompetech.com (search: "march", "military")
  - Recommended: "Soviet March" by Kevin MacLeod (literally perfect)
- OpenGameArt music section
- Purple Planet Music (free with attribution)

**Option 3: Create Your Own** (Most work, most control)

**Tools:**
- LMMS (desktop DAW, free)
- BeepBox (web-based, simpler)
- FamiTracker (NES-style chiptunes)

**Steps:**
1. Learn basic DAW usage (2-hour YouTube tutorial)
2. Start with drum pattern (4/4 march beat)
3. Add bassline (root notes, simple)
4. Add melody (Soviet song fragment or original)
5. Export loop (2-3 minutes)

### Part B: Create/Source Tracks (Day 2-3)

**Required Tracks (Minimum Viable):**

1. **menu_theme.ogg** (2 minutes loop)
   - Mood: Welcoming, slightly heroic
   - Tempo: Moderate (100-120 BPM)
   - Source: "The Internationale" SID or Kevin MacLeod "Soviet March"

2. **gameplay_main.ogg** (3 minutes loop)
   - Mood: Upbeat, march-like, not stressful
   - Tempo: Medium (110-130 BPM)
   - Source: "Katyusha" SID or original composition

3. **victory.ogg** (15 seconds, one-shot)
   - Mood: Triumphant fanfare
   - Reference: 4-bar victory jingle
   - Source: Create in ChipTone or clip from longer track

**Optional Tracks:**

4. **gameplay_intense.ogg** (For late waves)
   - Same as gameplay_main but faster tempo (+10-20 BPM)
   - Can be same track sped up in Audacity (Effect > Change Tempo)

5. **defeat.ogg** (10 seconds, one-shot)
   - Mood: Somber but not depressing
   - Reference: Descending melody, minor key
   - Source: Reverse/slow down victory theme

### Part C: Integration & Looping (Day 3)

**Looping Techniques:**

**Method 1: Crossfade Loop** (Easiest)
1. In Audacity, duplicate first 2 seconds to end of track
2. Apply crossfade (Effect > Crossfade Tracks)
3. Result: Seamless loop even if song doesn't naturally loop

**Method 2: Measure-Perfect Loop** (Best quality)
1. Ensure song is exactly N bars long (e.g., 32 bars at 120 BPM = 64 seconds)
2. Trim silence from start/end
3. Test loop point (play end → start transition)
4. Adjust if there's a click or gap

**Godot Loop Metadata** (OGG only):
- Add loop points using **Audacity Metadata Editor**
- Or rely on AudioManager restart behavior

**Integration Steps:**
- [ ] Place files in `assets/audio/music/`
- [ ] Update AudioManager to auto-play menu_theme on MainMenu scene
- [ ] Update Main.gd to play gameplay_main on level start
- [ ] Test music volume slider (if implemented)
- [ ] Ensure music doesn't restart on wave transitions (should keep playing)

### Phase 2 Acceptance Criteria ✅

- [ ] 3 music tracks created (menu, gameplay, victory)
- [ ] Tracks loop seamlessly
- [ ] Music transitions correctly (menu → game → victory)
- [ ] Volume balanced with SFX (music doesn't drown out combat)
- [ ] **Playtest feels like a "real game" now**

**Deliverable**: Fully scored game with atmospheric audio.

---

## 🎨 PHASE 3: Enemy Sprites (4-7 days) ⭐ HIGHEST VISUAL IMPACT

**Goal**: Replace procedural enemy rectangles with actual pixel art sprites with walk animations.

**Why Third?**: Enemies are constantly moving and visible. Players see them more than anything else.

### Part A: Art Direction & Palette (Day 1, 2-3 hours)

**Define Pixel Art Constraints:**
- Base canvas size: 16x24 pixels (current placeholder size)
- Scale factor: 5x (displayed as 80x120) ← Already in code
- Color limit: 8-16 colors per sprite (keep it simple)
- Animation: 2-frame walk cycle minimum, 4-frame death sequence

**Extract Color Palette from demo.png:**
```
Soviet Greens:   #4A5D3F, #6B7C5E, #3C4A31
Industrial Grays: #7A7A7A, #5A5A5A, #3A3A3A
Capitalist Blues: #2B3A5C, #1F2A3F (suits)
Flesh Tones:      #E8B896, #D4A574 (faces)
Red Accents:      #A3302F, #D64545 (stars, ties)
Background Tan:   #C9B896, #A89874
```

**Create Palette File:**
- Use Aseprite or GIMP to create .pal file
- Lock palette to prevent color drift
- Share palette across all sprites for consistency

### Part B: Enemy #1 - Businessman (Day 2, ~4 hours)

**Reference**: Blue suit, briefcase, capitalist look (from demo2.png businessman sprite)

**Sprite Spec:**
- Size: 16x24 pixels
- Key features: Blue suit, red tie, black hat, briefcase
- Expression: Neutral/focused face

**Creation Steps:**

**Option A: Manual Pixel Art** (If you're artistic)
1. Open Aseprite/Piskel, create 16x24 canvas
2. Block out basic shapes (head, body, legs)
3. Add details (suit lines, tie, briefcase)
4. Add shading (1-2 tones per color for depth)
5. Create 2-frame walk cycle:
   - Frame 1: Left leg forward, briefcase swings right
   - Frame 2: Right leg forward, briefcase swings left
6. Create 4-frame death sequence (use existing death_frames pattern)

**Option B: Trace & Modify** (Recommended for speed)
1. Find similar sprite on OpenGameArt (search "pixel businessman")
2. Import as reference layer
3. Trace basic shapes, adjust to 16x24
4. Modify details (add briefcase, change colors)
5. Create animations

**Option C: AI-Assisted** (Experimental)
1. Use Stable Diffusion with "pixel art" prompt
2. Generate businessman sprite at 16x24
3. Clean up in pixel editor
4. Manually create animations

**Export:**
- Walk Frame 1: `businessman_walk1.png` (16x24)
- Walk Frame 2: `businessman_walk2.png` (16x24)
- Death frames: 4 separate PNGs or sprite sheet

**Code Integration:**
- Update `PixelArtHelper.gd` to load PNG files instead of generating
- Or keep generation as fallback, add PNG overlay

### Part C: Enemy #2 - Tourist (Day 3, ~4 hours)

**Reference**: Bright casual clothes, camera, Hawaiian shirt

**Sprite Spec:**
- Size: 16x24 pixels
- Key features: Bright blue shirt, yellow hat, camera, shorts
- Expression: Happy/oblivious

**Creation Steps:**
- Follow same process as Businessman
- Focus on bright color contrast (vs. Businessman's dark suit)
- Camera should be visible prop (3x3 pixel camera at side)

**Animations:**
- Walk cycle: Bouncy stride (head bobs up/down slightly)
- Death: Camera drops, comedic fall

### Part D: Enemy #3 - Spy (Day 4, ~4 hours)

**Current State**: Already has procedural walking/death in code! ✅

**Task**: Create actual sprite art to match existing animations

**Sprite Spec:**
- Size: 16x24 pixels
- Key features: Dark gray trench coat, fedora, sunglasses
- Expression: Mysterious, face partially hidden

**Creation Steps:**
- Reference existing `create_spy_walk_frame1/2` for poses
- Recreate with actual pixel art detail
- Add shading to coat (noir style)
- Keep mysterious vibe (minimal facial features)

**Animations:**
- Walk: Sneaky stride (coat flaps)
- Death: Dramatic fall, hat flies off

### Part E: Enemy #4 - CEO Boss (Day 5-6, ~6 hours)

**Reference**: Larger enemy, expensive suit, crown, cigar

**Sprite Spec:**
- Size: 24x32 pixels (bigger than others)
- Key features: Pinstripe suit, gold crown, cigar, angry face
- Expression: Intimidating boss

**Creation Steps:**
- Larger canvas = more detail possible
- Add pinstripe pattern (vertical lines)
- Crown should be prominent (3-5 pixel gold crown)
- Cigar with smoke particles (1-2 pixel gray puffs)

**Animations:**
- Walk: Powerful stride, coat billows
- Death: Dramatic collapse, crown falls (comedic)

### Part F: Integration & Testing (Day 7)

**Replace Procedural System:**

**Option 1: Full Replacement**
- Remove PixelArtHelper calls from enemy scripts
- Load PNG files directly via `preload()`
- Set up AnimatedSprite2D nodes with sprite frames

**Option 2: Hybrid Approach** (Recommended)
- Keep PixelArtHelper as fallback
- Check if PNG exists, use it; otherwise generate
- Allows gradual replacement, no hard cutover

**Code Changes:**
```gdscript
# In Businessman.gd
func _ready():
    # Try to load real sprite first
    var walk1 = load("res://assets/sprites/enemies/businessman_walk1.png")
    if walk1:
        setup_animations_from_files(walk1, walk2, death_frames)
    else:
        # Fallback to procedural
        var walk_frames = [
            PixelArtHelper.create_businessman_walk_frame1(),
            PixelArtHelper.create_businessman_walk_frame2()
        ]
        setup_animations(walk_frames, death_frames)
```

**Testing Checklist:**
- [ ] All 4 enemy types display new sprites
- [ ] Walk animations play at correct speed (not too fast/slow)
- [ ] Death animations play fully before enemy despawns
- [ ] Sprites scale correctly (5x multiplier still applies)
- [ ] No visual glitches (clipping, wrong frames)

### Phase 3 Acceptance Criteria ✅

- [ ] 4 enemy types have unique pixel art sprites
- [ ] Each enemy has 2-frame walk cycle
- [ ] Each enemy has 4-frame death sequence
- [ ] Sprites match demo.png art style direction
- [ ] Game looks recognizably "Soviet Tower Defense" themed
- [ ] **Playtest feels like a real game visually**

**Deliverable**: Visually distinct enemies that bring the game's theme to life.

---

## 🏭 PHASE 4: Tower Sprites (3-5 days)

**Goal**: Replace tower placeholders with themed Soviet structures.

**Why Fourth?**: Towers are stationary, so less urgent than animated enemies. But still very visible.

### Part A: Tower #1 - Guard Tower (Day 1)

**Reference**: Watchtower with red star, military green (from demo.png background)

**Sprite Spec:**
- Size: 32x32 pixels
- Key features: Wooden guard post, red star, soldier visible in window
- Style: Military, functional

**Creation Steps:**
1. Base structure: Brown wood planks (vertical lines)
2. Platform/roof: Darker brown
3. Red star emblem on front (prominent)
4. Tiny soldier sprite in window (8x8 pixel head/shoulders)
5. Gun barrel protruding from side (3-5 pixel gray barrel)

**Optional Animation:**
- Muzzle flash when shooting (2-frame: normal, flash)
- Soldier turns to track enemies

### Part B: Tower #2 - Propaganda Speaker (Day 2)

**Reference**: Loudspeaker on pole, red color, sound waves

**Sprite Spec:**
- Size: 32x32 pixels
- Key features: Red speaker horn, pole/mount, Soviet iconography
- Style: Bold, propaganda poster aesthetic

**Creation Steps:**
1. Central pole: Gray metal (vertical)
2. Speaker horn: Red, megaphone shape
3. Speaker grill: Dark red horizontal lines
4. Red star or hammer/sickle symbol
5. Sound wave particles (when active): Yellow/white expanding circles

**Animation Ideas:**
- Speaker rotates slightly (2-3 frames)
- Sound waves pulse when slowing enemies

### Part C: Tower #3 - Bureaucratic Office (Day 3)

**Reference**: Small gray building, windows, papers flying out

**Sprite Spec:**
- Size: 32x32 pixels
- Key features: Gray concrete building, windows, door, bureaucratic feel
- Style: Utilitarian, Soviet architecture

**Creation Steps:**
1. Main building: Gray rectangular block
2. Windows: Dark squares (2x2 pixels each, 4 total)
3. Door: Brown rectangle at bottom
4. Roof: Darker gray, flat
5. Papers flying out: White rectangles tumbling from window

**Animation Ideas:**
- Papers continuously fly out when active
- Window lights up when attacking

### Part D: Tower #4 - Missile Station (Day 4)

**Reference**: Rocket launcher, military platform, missile visible

**Sprite Spec:**
- Size: 40x40 pixels (larger than other towers)
- Key features: Red missile, gray launch platform, support struts
- Style: Military hardware, angular

**Creation Steps:**
1. Base platform: Dark gray, angled
2. Support struts: Light gray diagonal lines
3. Missile: Red body, yellow/white nose cone
4. Fins: Dark red at base
5. Red star emblem on missile body

**Animation Ideas:**
- Missile raises to firing position (2-3 frames)
- Launch: missile disappears, smoke puff remains
- Reload: New missile rises into position

### Part E: Integration (Day 5)

**Implementation Strategy:**

**Option 1: Static Sprites** (Simpler)
- Single PNG per tower
- Load in tower scripts like enemies
- No shooting animations (projectiles provide feedback)

**Option 2: Animated Sprites** (Polish)
- Idle frame + shooting frame(s)
- Use AnimatedSprite2D
- Play "shoot" animation when `_fire_at_target()` is called

**Code Pattern:**
```gdscript
# In GuardTower.gd
@onready var sprite = $Sprite2D

func _ready():
    super() # Call BaseTower._ready()
    sprite.texture = load("res://assets/sprites/towers/guard_tower.png")
    # Scale already handled by BaseTower (scale = Vector2(5, 5))

func _fire_at_target(target):
    super(target) # Call base firing logic
    # Optional: Play muzzle flash
    $MuzzleFlash.visible = true
    await get_tree().create_timer(0.1).timeout
    $MuzzleFlash.visible = false
```

**Testing:**
- [ ] All 4 tower types have unique sprites
- [ ] Towers display correctly when placed
- [ ] Sprites don't interfere with range indicators
- [ ] Shooting animations (if implemented) sync with projectile spawning

### Phase 4 Acceptance Criteria ✅

- [ ] 4 tower types have thematic pixel art sprites
- [ ] Towers fit demo.png aesthetic (Soviet industrial)
- [ ] Sprites are recognizable at game scale
- [ ] Optional: Basic shooting animations implemented
- [ ] **Game now has cohesive visual identity**

**Deliverable**: Soviet-themed tower defense with recognizable tower types.

---

## 🎨 PHASE 5: UI Polish (2-4 days)

**Goal**: Add icons, panels, and visual polish to user interface.

**Why Fifth?**: UI is important but players tolerate plain UI if gameplay looks good.

### Part A: Currency & Status Icons (Day 1, ~2 hours)

**Icons Needed (16x16 pixels each):**

1. **icon_rubles.png**
   - Design: Ruble symbol (₽) or coin with star
   - Colors: Gold/yellow
   - Usage: Displayed next to currency counter

2. **icon_heart.png**
   - Design: Simple heart or red star
   - Colors: Red
   - Usage: Lives remaining indicator

3. **icon_wave.png**
   - Design: Flag or wave number badge
   - Colors: Red banner
   - Usage: Wave counter display

**Creation:**
- Can create in 30 mins total (simple 16x16 icons)
- Export as PNG with transparency
- Place in `assets/sprites/icons/`

### Part B: Tower Selection Buttons (Day 1-2, ~4 hours)

**Current State**: TowerButton.gd uses text labels

**Goal**: Replace with icon + name layout

**Icon Design (32x32 pixels each):**
- Use simplified version of tower sprites
- Or create unique icons (top-down view)
- Add border/frame (Soviet style: red star corners)

**Button Layout:**
```
┌─────────────┐
│   [ICON]    │  ← 32x32 tower icon
│  Tower Name │  ← Text label
│   💰 150    │  ← Cost
└─────────────┘
```

**Panel Background:**
- Create 9-patch panel texture (res://assets/ui/panel_bg.png)
- Style: Gray concrete or red propaganda poster
- Add rivets, red stars, or Cyrillic text for flavor

### Part C: Upgrade Panel Icons (Day 2, ~2 hours)

**Icons Needed:**

1. **icon_upgrade.png** (16x16)
   - Design: Up arrow or star with +
   - Colors: Yellow/gold

2. **icon_sell.png** (16x16)
   - Design: Trash can or rubles returning
   - Colors: Red/gray

**Panel Redesign:**
- UpgradePanel.tscn currently uses plain buttons
- Add icon graphics
- Add tower portrait (64x64 version of tower sprite)

### Part D: Game State Screens (Day 3-4, ~4 hours)

**Victory Screen:**
- Large red star or Soviet banner graphic
- "VICTORY FOR THE PEOPLE!" text
- Stats display (waves survived, enemies killed)

**Defeat Screen:**
- Somber gray background
- "MOTHERLAND NEEDS YOU" or similar text
- Retry button with Soviet aesthetic

**Pause Menu:**
- Semi-transparent overlay
- Soviet-styled buttons (resume, settings, quit)
- Optional: Propaganda poster background

**Creation Tips:**
- These can be simple (text + colored backgrounds)
- Add one thematic graphic per screen (star, hammer/sickle, banner)
- Focus on readability over decoration

### Phase 5 Acceptance Criteria ✅

- [ ] Currency/status icons implemented
- [ ] Tower buttons have icon graphics
- [ ] Upgrade panel has icons
- [ ] Victory/defeat screens are themed
- [ ] UI feels cohesive with game theme
- [ ] **Game looks "finished" from UI perspective**

**Deliverable**: Polished, thematic user interface.

---

## ✨ PHASE 6: Effects & VFX (2-3 days)

**Goal**: Add visual feedback for combat and game events.

**Why Sixth?**: Effects are polish-tier. Game is playable without them but they add juice.

### Part A: Explosion Effects (Day 1, ~3 hours)

**Sprite Spec:**
- Size: 32x32 pixels
- Frames: 4-6 frame animation
- Style: Pixel art explosion (expanding circle + smoke)

**Animation Sequence:**
1. Frame 1: Small bright flash (yellow/white)
2. Frame 2: Expanding circle (orange/red)
3. Frame 3: Larger circle + smoke particles (orange/gray)
4. Frame 4: Dissipating smoke (gray, fading)
5. Frames 5-6: Fade out

**Implementation:**
- Create AnimatedSprite2D scene: `Explosion.tscn`
- On enemy death, spawn explosion at enemy position
- Play animation, queue_free() on completion

**Usage:**
```gdscript
# In BaseEnemy.gd death function
func _on_death():
    var explosion = preload("res://scenes/effects/Explosion.tscn").instantiate()
    get_parent().add_child(explosion)
    explosion.global_position = global_position
    explosion.play()
    queue_free()
```

### Part B: Muzzle Flashes (Day 1, ~2 hours)

**Sprite Spec:**
- Size: 16x16 pixels
- Frames: 2 frames (flash on, flash off)
- Style: Bright yellow/white starburst

**Implementation:**
- Add to tower scenes as child node
- Trigger when tower fires
- Display for 0.1 seconds

### Part C: Projectile Trails (Day 2, ~3 hours)

**Options:**

**Option 1: Sprite Trail**
- Small particle sprite (4x4 pixel)
- Spawns behind bullet every 0.1 seconds
- Fades out over 0.3 seconds

**Option 2: Godot Particles** (Easier)
- Use CPUParticles2D or GPUParticles2D
- Attach to Bullet.tscn
- Trail emits gray/white smoke particles

**Recommendation**: Use Godot's particle system (faster to implement)

### Part D: Propaganda Wave Effect (Day 2-3, ~3 hours)

**For Propaganda Speaker Tower:**

**Effect Design:**
- Expanding red circle waves (like sound waves)
- Emanate from speaker, pulse outward
- Enemies in range get visual "slow" indicator

**Implementation:**
```gdscript
# In PropagandaSpeaker.gd
func _on_enemy_slowed(enemy):
    var wave = preload("res://scenes/effects/PropagandaWave.tscn").instantiate()
    add_child(wave)
    wave.play_wave()
```

**Visual:**
- 3-frame animation: Small → Medium → Large circle
- Color: Red with transparency
- Duration: 0.5 seconds, loops while tower active

### Part E: Coin Pickup Effect (Day 3, ~2 hours)

**When enemy dies and player earns rubles:**

**Effect Design:**
- Gold coin sprite (16x16) floats upward
- "+X ₽" text appears briefly
- Floats toward currency counter (optional advanced)

**Implementation:**
- Spawn at enemy death position
- Tween upward + fade out
- Simple but satisfying

### Phase 6 Acceptance Criteria ✅

- [ ] Explosions play on enemy death
- [ ] Muzzle flashes on tower shooting
- [ ] Projectiles have trails (optional)
- [ ] Propaganda tower has wave effect
- [ ] Coin effects on enemy death
- [ ] **Game feels dynamic and reactive**

**Deliverable**: Juicy, satisfying visual feedback.

---

## 🎙️ PHASE 7: Voice Lines (1-2 days)

**Goal**: Add optional Russian voice lines for atmosphere.

**Why Seventh?**: This is pure polish and requires external help (Russian friends).

### Part A: Script Writing (Day 1, ~2 hours)

**Voice Line Categories:**

**Commander Voice** (Encouraging/instructional):
- Wave Start: "Товарищ, капиталисты приближаются!" (Capitalists approaching!)
- Tower Placed: "Отличная работа!" (Excellent work!)
- Base Hit: "Защищай Родину!" (Defend the Motherland!)
- Low Funds: "Нам нужно больше рублей!" (We need more rubles!)
- Victory: "Победа за народом!" (Victory for the people!)
- Defeat: "Мы подвели Родину..." (We failed the Motherland...)

**Enemy Death Lines** (Comedic, English):
- Businessman: "My portfolio!" or "Sell! Sell! Sell!"
- Tourist: "This wasn't in the brochure!"
- CEO: "I'll sue you for this!"
- Spy: "Clever girl..." (fading, mysterious)

**Propaganda Tower Lines** (Russian, looped):
- "Трудящиеся всех стран, соединяйтесь!" (Workers of the world, unite!)
- "Долой капитализм!" (Down with capitalism!)
- Radio static + muffled speech

### Part B: Recording Session (Day 1-2, ~3 hours)

**Preparation:**
- Write phonetic pronunciations for Russian lines
- Practice delivery (over-the-top propaganda voice)
- Set up quiet recording space

**Recording Tips:**
- Use phone or basic mic (quality less important for comedic effect)
- Record multiple takes (pick best)
- Do serious take + comedic take for each line
- Add echo/reverb in post for propaganda effect

**Friend Involvement:**
- Russian friends record native lines (15 min session each)
- Can record via voice message, you clean up later

### Part C: Post-Processing (Day 2, ~2 hours)

**In Audacity:**
1. Import recordings
2. Noise reduction (remove background hiss)
3. Normalize volume (-3dB)
4. Add effects:
   - Commander voice: Slight radio static filter
   - Propaganda lines: Echo + low-pass filter (muffled speaker sound)
   - Enemy deaths: Pitch shift (optional, for variety)
5. Export as OGG Vorbis

### Part D: Integration (Day 2, ~1 hour)

**Trigger Points:**
```gdscript
# In WaveManager.gd
func start_wave():
    AudioManager.play_voice("res://assets/audio/voice/wave_incoming.ogg")

# In TowerManager.gd
func place_tower():
    AudioManager.play_voice("res://assets/audio/voice/tower_built.ogg")

# In EconomyManager.gd
func lose_life():
    if lives <= 5:
        AudioManager.play_voice("res://assets/audio/voice/base_damaged.ogg")
```

**Cooldown System:**
- Don't spam voice lines (max 1 per 5 seconds)
- Add simple cooldown timer in AudioManager

### Phase 7 Acceptance Criteria ✅

- [ ] 6-8 voice lines recorded and processed
- [ ] Lines trigger at appropriate game moments
- [ ] Volume balanced (not too loud)
- [ ] Russian pronunciation is correct (validated by native speaker)
- [ ] Lines add atmosphere without annoying player
- [ ] **Game has authentic Soviet flavor**

**Deliverable**: Atmospheric voice acting that enhances theme.

---

## 🌆 PHASE 8: Backgrounds (3-5 days)

**Goal**: Replace plain backgrounds with parallax Soviet industrial scenes.

**Why Last?**: Backgrounds are least critical. Players focus on gameplay, not scenery.

### Part A: Reference & Planning (Day 1, ~2 hours)

**Study demo.png background layers:**
1. **Far layer**: Silhouette cityscape (factories, smokestacks)
2. **Mid layer**: Buildings with "DOWN WITH CAPITALISM" sign
3. **Near layer**: Ground/path where enemies walk

**Parallax Effect:**
- Far layer: Moves slowest (0.2x camera speed)
- Mid layer: Moves medium (0.5x camera speed)
- Near layer: Moves with camera (1.0x)

**Color Scheme:**
- Sky: Dusty orange/tan (sunset/smog)
- Buildings: Gray, brown (industrial)
- Accents: Red propaganda signs, smokestacks

### Part B: Create Background Layers (Day 2-4)

**Layer 1: Sky (1920x1080)**
- Gradient from tan (top) to orange (bottom)
- Optional: Add clouds (simple shapes)
- Tool: GIMP gradient or pixel art

**Layer 2: Far Cityscape (1920x300)**
- Silhouette skyline (buildings, smokestacks)
- Color: Dark gray/black
- Style: Simple shapes, recognizable (Lenin statue, factories)

**Layer 3: Mid Buildings (1920x400)**
- Detailed buildings with windows
- Propaganda posters: "DOWN WITH CAPITALISM" (English or Russian)
- Color: Gray concrete, red signs

**Layer 4: Foreground Path (1920x200)**
- Ground where enemies walk
- Color: Brown dirt or gray pavement
- Optional: Grass tufts, rubble details

**Creation Methods:**

**Option 1: Pixel Art** (Most control)
- Create each layer in Aseprite at 384x216 (1/5 scale)
- Scale up 5x (matches game art style)
- Export as PNG

**Option 2: Photo Manipulation** (Fastest)
- Find CC0 industrial photos
- Apply posterize/pixelate filter
- Add propaganda signs as overlays

**Option 3: Tileable Backgrounds** (Smart approach)
- Create 512x512 tileable section
- Repeat horizontally for scrolling
- Less art work, same effect

### Part C: Implementation (Day 5)

**In TestLevel.tscn (or BaseLevel.tscn):**

1. Create ParallaxBackground node
2. Add ParallaxLayer nodes (one per background layer)
3. Set motion_scale for each layer:
   - Sky: Vector2(0.1, 1.0)
   - Far: Vector2(0.3, 1.0)
   - Mid: Vector2(0.6, 1.0)
   - Near: Vector2(1.0, 1.0)
4. Add Sprite2D to each layer with background texture

**Testing:**
- [ ] Backgrounds scroll smoothly
- [ ] No gaps or seams in scrolling
- [ ] Layers move at different speeds (parallax effect works)
- [ ] Colors don't clash with game sprites

### Phase 8 Acceptance Criteria ✅

- [ ] Multi-layer parallax background implemented
- [ ] Backgrounds match demo.png aesthetic
- [ ] No performance issues (backgrounds are static images)
- [ ] Propaganda signs visible and thematic
- [ ] **Game looks like the demo screenshots**

**Deliverable**: Immersive Soviet industrial atmosphere.

---

## 🎯 PHASE 9: Final Polish (Ongoing)

**Goal**: Continuous refinement based on playtesting feedback.

**Activities:**

### Playtesting Iteration
- [ ] Recruit 3-5 playtesters
- [ ] Gather feedback on clarity, difficulty, aesthetics
- [ ] Prioritize top 3 issues per test session
- [ ] Implement quick fixes, iterate

### Asset Refinement
- [ ] Improve sprites based on feedback (too small? unclear?)
- [ ] Adjust audio volumes (common complaint)
- [ ] Tweak animations (too fast/slow?)

### Bonus Polish
- [ ] Add screen shake on explosions
- [ ] Add tower idle animations (soldier looks around)
- [ ] Add more voice line variety
- [ ] Create alternate tower skins (DLC idea?)

### Performance Optimization
- [ ] Profile on target Android device
- [ ] Optimize sprite atlases
- [ ] Reduce particle counts if needed

### Localization Prep (Optional)
- [ ] Extract all UI text to localization file
- [ ] Create Russian translation
- [ ] Test both English/Russian modes

---

## 📊 Progress Tracking

### How to Use This Roadmap

1. **Mark phases as you complete them** (update Status column)
2. **Set realistic daily goals** (e.g., "Today: Complete 3 SFX sounds")
3. **Don't skip phases** (audio first is critical for motivation)
4. **Playtest after each phase** (validate before moving on)
5. **Adjust estimates** (your first sprite might take 6 hours, 4th might take 2)

### Milestone Celebrations 🎉

- **Phase 1 Complete**: Game has sound! (Huge morale boost)
- **Phase 2 Complete**: Game is fully scored (Feels like real game)
- **Phase 3 Complete**: Enemies look great (Biggest visual jump)
- **Phase 6 Complete**: Game is feature-complete asset-wise
- **Phase 8 Complete**: Game matches demo screenshots (SHIP IT!)

### Time Tracking Template

```
Phase: _______________
Start Date: __________
Est. Hours: __________
Actual Hours: ________
Notes: _______________
```

---

## 🚀 Quick Start Action Plan

**This Week** (Focus: Audio Foundation):
- [ ] Day 1: Phase 0 setup (tools installed)
- [ ] Day 2-3: Phase 1A (combat sounds)
- [ ] Day 4: Phase 1B (UI sounds)
- [ ] Day 5: Phase 1C (wave sounds)
- [ ] Weekend: Playtest with audio, rest

**Next Week** (Focus: Music):
- [ ] Day 1: Research SID music
- [ ] Day 2-3: Create/convert 3 music tracks
- [ ] Day 4: Integrate and loop music
- [ ] Day 5: Buffer/polish

**Week 3-4** (Focus: Visuals):
- Phase 3: Enemy sprites
- Phase 4: Tower sprites

---

## ✅ Definition of Done

**An asset is "done" when:**
1. File is created and exported to correct directory
2. Game loads and displays/plays asset correctly
3. Asset matches demo.png style direction
4. No bugs or visual/audio glitches
5. Playtester can identify what asset represents (clarity test)

**A phase is "done" when:**
1. All checkboxes marked complete
2. Acceptance criteria met
3. Playtest session validates improvements
4. You feel good about moving to next phase (gut check)

---

## 💡 Pro Tips

1. **Batch similar tasks** (record all voice lines in one session, not spread out)
2. **Use placeholder text** ("TEMP - Replace later") for assets you're not satisfied with
3. **Keep a "cut content" folder** for assets that didn't make it (might use later)
4. **Version control your assets** (commit after each phase)
5. **Take breaks between phases** (prevents burnout)
6. **Show progress publicly** (Twitter, Discord - external motivation)
7. **Perfect is the enemy of done** (80% quality, 100% complete > 100% quality, 0% complete)

---

## 🎨 Inspiration & Resources

**Pixel Art Tutorials:**
- [MortMort's Pixel Art Course](https://www.youtube.com/playlist?list=PLR3Ra9cf8aV06i2jKmgKvcYVHI86-4K_b) (YouTube)
- [Pedro Medeiros' Pixel Art Articles](https://blog.studiominiboss.com/pixelart) (Blog)

**Audio Production:**
- [How to Make Retro Game SFX](https://www.youtube.com/watch?v=qFTKNg-GFz4) (SFXR tutorial)
- [Game Audio for Beginners](https://www.youtube.com/watch?v=M5b-t0J4yWQ) (Audacity basics)

**Soviet Aesthetic Reference:**
- [Soviet Posters](https://www.sovietposters.com/) (Visual inspiration)
- [USSR Anthem & Songs](https://www.youtube.com/c/SovietAnthems) (Music reference)

**Motivation:**
- Remember: **Finished game with OK art > Perfect game that's never done**
- Your demo screenshots prove this art style is achievable
- Every small improvement is visible progress

---

**Ready to start, comrade? Begin with Phase 0 and work your way through. Victory awaits! 🚩**
