# NovaPlates 0.3.0

Compact nameplates for World of Warcraft WotLK 3.3.5a (Interface 30300), developed for Warmane.

## Download and install

Download **NovaPlates-0.3.0-WotLK.zip** from [Releases](https://github.com/sobata1995-source/NovaPlates/releases/latest). Extract the NovaPlates folder into `Interface/AddOns`, replace the entire older addon folder, and run `/reload`. Enable enemy nameplates with **V**.

## Features

- PvP cooldown estimates in FIFO cast order: oldest on the left, newest on the right.
- Five visible icons with a +N queue; hidden timers keep counting down.
- 382 ability groups / 1028 spell IDs including ranks, class abilities, racials and pets with a known owner.
- Compact plates, player class colors and automatic cooldown tracking on login/reload.
- PvE threat colors: red for your aggro, yellow for high threat, green for the selected tank.
- Hostile and neutral NPCs remain distinguishable; NPC/boss cooldowns are excluded.

Use `/np tank` with your tank targeted, `/np compact`, `/np test`, or `/np status` for diagnostics. [Bulgarian guide](NovaPlates/README_BG.md) · [Spell catalog and sources](NovaPlates/SPELL_CATALOG.md).

Cooldowns start after observed casts and use base estimates. Talents, glyphs and server changes can affect timing. Not every consumable or on-use item is covered. Legacy nameplate identification depends on visible native frames and observed units; other nameplate addons can conflict.

Lua 5.1 and mocked WoW API regression checks passed during development. The user confirmed version 0.3.0 working on their client; this is not exhaustive class/server testing.
