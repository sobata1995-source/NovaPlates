# NovaPlates Forever 0.1.0 alpha

Target: Forever 1.60.1 / interface 16001.

Uses the client's native Thin/Small nameplate layout with enemy stacking. Preserves native health, names, casts, targeting and player colors. Does not read or alter protected health values.

NPC colors: red = player threat status 2/3 (or mob targeting player); yellow = threat status 1; green = a mob in combat targeting an assigned group tank or manually selected tank; orange-red = hostile reaction; gold = neutral reaction; blue = friendly reaction. Green is based on current target, not a guaranteed threat-table lead. If player threat/reaction data is secret, native Blizzard colors are preserved.

Commands:
- /np compact: enable compact preset and custom NPC colors.
- /np tank: select a friendly player first to assign a tank.
- /np tank clear: clear manual tank; group tank roles still work.
- /np restore: disable custom colors and restore saved nameplate CVars. Changes defer until combat ends.
- /np status: version, attached plates and hook state.

Cooldown tracking is intentionally disabled. NovaPlatesForeverProbe remains a separate addon with /npf status for later testing.

Validation: Lua 5.1 mocked tests cover NPC reactions, threat colors, restricted values, native fallback, player/dead units, settings restoration, combat deferral and frame removal. Live in-client visual and combat testing remains required.
