# NovaPlates

### Compact plates. Visible cooldowns. Clear threat.

Modern nameplates for **WoW WotLK 3.3.5a / Warmane**, combining enemy PvP cooldown tracking with readable PvE tank threat colors.

[![Download](https://img.shields.io/badge/Download-v0.3.1-20BFA9?style=for-the-badge)](https://github.com/sobata1995-source/NovaPlates/releases/latest)
[![Support / Donate via Revolut](https://img.shields.io/badge/Support%20%2F%20Donate-Revolut-0075EB?style=for-the-badge)](https://revolut.me/denisar2z)

## New in 0.3.1

Same-faction duel opponents retain their cooldown icons after target changes once attackability has been observed. The cached eligibility clears when the duel finishes. The regression fails on 0.3.0 and passes on 0.3.1.

## PvP cooldowns above the enemy

See what your opponent just used without losing sight of their nameplate. The catalog includes **382 ability groups / 1,028 spell IDs**, covering ranks, class abilities, racials and pet abilities with a known owner.

**FIFO: first in, first out.** The oldest observed cast is on the left; new casts join on the right. Five icons remain visible, with **+N** for queued entries. Hidden timers keep running. Expired entries disappear wherever they are, and remaining icons retain their order.

- Color-coded borders for interrupts, defensives, burst, crowd control, mobility and trinkets.
- Includes Death Grip, Divine Shield, Avenging Wrath and many more.
- Class-colored player plates when the class is known.
- Automatic tracking at login/reload and compact plate sizes.

## PvE threat at a glance

| Color | Meaning |
|---|---|
| 🔴 Red | You have aggro |
| 🟡 Yellow | High threat / close to pulling aggro |
| 🟢 Green | The identified enemy targets your selected tank |

Hostile and neutral NPCs stay distinguishable. PvE retains cast bars and threat tracking; NPC/boss cooldowns are excluded. Target your tank and run `/np tank`, or use `/np tank auto` for raid Main Tank assignments.


## In-game gallery

### Hunter duel — cooldowns above the target

![Hunter duel with three cooldown timers](https://github.com/user-attachments/assets/9b2c6a96-b3c8-4000-a696-3e9899c72e42)

### Warrior duel — class colors and a neutral NPC nearby

![Warrior duel and yellow neutral NPC plate](https://github.com/user-attachments/assets/bc8ca276-0380-4fde-be5e-7e8977abcd33)

### Five visible cooldowns in combat

![Five cooldown timers above the warrior nameplate](https://github.com/user-attachments/assets/fc6b759b-8710-43a7-b572-0f5d5966e75d)

Real screenshots supplied from in-game duels. The gallery shows PvP cooldowns and neutral NPC distinction, not a PvE tank-threat test.

## Installation

1. Download **NovaPlates-0.3.1-WotLK.zip** from [Releases](https://github.com/sobata1995-source/NovaPlates/releases/latest).
2. Extract the **NovaPlates** folder into `World of Warcraft/Interface/AddOns/`.
3. Replace the entire older addon folder, including `SpellData.lua`, and run `/reload`.
4. Press **V** to enable enemy nameplates. Disable other addons that replace the same plates.

Use the attached addon ZIP; GitHub's automatic source archives contain an extra repository folder.

## Commands

| Command | Action |
|---|---|
| `/np compact` | Restore compact plate sizes |
| `/np tank` | Set the current target as your tank |
| `/np test` | Toggle the demonstration panel |
| `/np status` | Show diagnostics |
| `/np scale 0.9` | Adjust plate scale |

[Българско ръководство](NovaPlates/README_BG.md) · [Full spell catalog and sources](NovaPlates/SPELL_CATALOG.md)

## Compatibility and timing

Made for the original **3.3.5a client (Interface 30300)**. Icons start after observed casts and show **base cooldown estimates**. Talents, glyphs and server changes can affect timing. Not every consumable or on-use item is included. Pet timers need an identified owner. Legacy nameplate matching depends on visible native frames and observed units.

Lua 5.1 and simulated WoW API checks passed during development. The supplied in-game screenshots show cooldowns during hunter and warrior duels. This is not exhaustive testing of every ability or server.

## Support development

[![Support / Donate via Revolut](https://img.shields.io/badge/Support%20%2F%20Donate-Revolut-0075EB?style=for-the-badge)](https://revolut.me/denisar2z)

Enjoy NovaPlates? You can leave an optional tip via Revolut: **[@denisar2z](https://revolut.me/denisar2z)**. The addon remains free; donations are entirely voluntary. Thank you for your support!
