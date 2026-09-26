# WotLK cooldown catalog

382 ability groups; 1028 spell IDs including ranks.

Scope: every non-passive spell in the source class, racial and pet skill lines and talent rows with a base recovery/category recovery above 1.5 seconds, plus PvP trinket 42292. The list includes utility abilities. Rune recovery and GCD-only spells are not ability cooldowns. It does not cover every consumable, engineering item or on-use item.

Times are base estimates before talents/glyphs/server changes. Pet timers require an observed owner link. Same-name ranks normalize within spell family/category/actor, not across classes.

[Numeric source tables](https://github.com/Kaev/AzerothcoreDBCToSQL) / [Spell schema](https://github.com/azerothcore/wiki/blob/master/docs/spell.md). Only numeric facts and spell identifiers/names are distributed here, not the original SQL or addon implementation.

## Source checksums

- Spell.sql SHA-256: `4b1d4dad432be85099ad7b4de35f082820da59892fdf49fee9afc47162b0ecc6`
- SkillLine.sql SHA-256: `2983117472ee2ebfac664ae065f75c388bb76dc19f7c40c1b39956093262bf52`
- SkillLineAbility.sql SHA-256: `027a1a24b5c780ee74342ec19a245699522a600553cbcfa735bbda26817391f4`
- Talent.sql SHA-256: `eff2869b50fa610adbe6532040a0558c795eed7c5bbbfc9dfa4a59710c19b16c`

Six malformed upstream SQL rows were excluded; none belongs to the selected skill/talent set.

| ID | Ability | Group | Base seconds | Ranks |
|---|---|---|---|---|
| 47481 | Gnaw | Pet | 60 | 1 |
| 47484 | Huddle | Pet | 45 | 1 |
| 47482 | Leap | Pet | 20 | 1 |
| 4511 | Phase Shift | Pet | 10 | 1 |
| 33395 | Freeze | Pet | 25 | 1 |
| 30213 | Cleave | Pet | 6 | 4 |
| 33698 | Anguish | Pet | 5 | 4 |
| 19505 | Devour Magic | Pet | 8 | 7 |
| 30151 | Intercept | Pet | 30 | 4 |
| 7814 | Lash of Pain | Pet | 12 | 1 |
| 7815 | Lash of Pain | Pet | 12 | 8 |
| 7812 | Sacrifice | Pet | 60 | 9 |
| 54049 | Shadow Bite | Pet | 6 | 5 |
| 6360 | Soothing Kiss | Pet | 4 | 5 |
| 19244 | Spell Lock | Pet | 24 | 2 |
| 17735 | Suffering | Pet | 120 | 8 |
| 3716 | Torment | Pet | 5 | 8 |
| 55749 | Acid Spit | Pet | 10 | 6 |
| 50433 | Bad Attitude | Pet | 120 | 6 |
| 53490 | Bullheaded | Pet | 180 | 1 |
| 53434 | Call of the Wild | Pet | 300 | 1 |
| 54044 | Carrion Feeder | Pet | 30 | 1 |
| 61685 | Charge | Pet | 25 | 1 |
| 1742 | Cower | Pet | 45 | 1 |
| 61684 | Dash | Pet | 32 | 1 |
| 24423 | Demoralizing Screech | Pet | 10 | 6 |
| 23145 | Dive | Pet | 32 | 1 |
| 50285 | Dust Cloud | Pet | 40 | 1 |
| 34889 | Fire Breath | Pet | 10 | 6 |
| 54644 | Froststorm Breath | Pet | 10 | 6 |
| 24604 | Furious Howl | Pet | 40 | 6 |
| 35290 | Gore | Pet | 10 | 6 |
| 2649 | Growl | Pet | 5 | 9 |
| 55709 | Heart of the Phoenix | Pet | 480 | 1 |
| 53476 | Intervene | Pet | 30 | 1 |
| 53478 | Last Stand | Pet | 360 | 1 |
| 58604 | Lava Breath | Pet | 10 | 6 |
| 53426 | Lick Your Wounds | Pet | 180 | 1 |
| 24844 | Lightning Breath | Pet | 10 | 6 |
| 54680 | Monstrous Bite | Pet | 10 | 6 |
| 50479 | Nether Shock | Pet | 40 | 6 |
| 50245 | Pin | Pet | 40 | 6 |
| 35387 | Poison Spit | Pet | 10 | 6 |
| 24450 | Prowl | Pet | 10 | 3 |
| 26090 | Pummel | Pet | 30 | 1 |
| 53401 | Rabid | Pet | 45 | 1 |
| 59881 | Rake | Pet | 10 | 6 |
| 50518 | Ravage | Pet | 40 | 6 |
| 53517 | Roar of Recovery | Pet | 180 | 1 |
| 53480 | Roar of Sacrifice | Pet | 60 | 1 |
| 50498 | Savage Rend | Pet | 60 | 6 |
| 24583 | Scorpid Poison | Pet | 10 | 6 |
| 50318 | Serenity Dust | Pet | 60 | 6 |
| 26064 | Shell Shield | Pet | 60 | 1 |
| 50541 | Snatch | Pet | 60 | 6 |
| 50519 | Sonic Blast | Pet | 60 | 6 |
| 61193 | Spirit Strike | Pet | 10 | 6 |
| 50274 | Spore Cloud | Pet | 10 | 6 |
| 57386 | Stampede | Pet | 60 | 6 |
| 56626 | Sting | Pet | 6 | 6 |
| 50256 | Swipe | Pet | 5 | 6 |
| 52825 | Swoop | Pet | 25 | 1 |
| 53477 | Taunt | Pet | 180 | 1 |
| 50271 | Tendon Rip | Pet | 20 | 6 |
| 63900 | Thunderstomp | Pet | 10 | 1 |
| 54706 | Venom Web Spray | Pet | 40 | 6 |
| 35346 | Warp | Pet | 15 | 1 |
| 4167 | Web | Pet | 40 | 1 |
| 53508 | Wolverine Bite | Pet | 10 | 1 |
| 25046 | Arcane Torrent | Racial / Other | 120 | 3 |
| 26297 | Berserking | Racial / Other | 180 | 1 |
| 20572 | Blood Fury | Racial / Other | 120 | 3 |
| 20577 | Cannibalize | Racial / Other | 120 | 1 |
| 50977 | Death Gate | Racial / Other | 60 | 1 |
| 54785 | Demon Charge | Racial / Other | 45 | 1 |
| 20589 | Escape Artist | Racial / Other | 105 | 1 |
| 59752 | Every Man for Himself | Racial / Other | 120 | 1 |
| 6991 | Feed Pet | Racial / Other | 10 | 1 |
| 30874 | Gift of the Water Spirit | Racial / Other | 300 | 1 |
| 60970 | Heroic Fury | Racial / Other | 45 | 1 |
| 1122 | Inferno | Racial / Other | 600 | 1 |
| 42292 | PvP Trinket | Racial / Other | 120 | 1 |
| 58984 | Shadowmeld | Racial / Other | 120 | 1 |
| 29858 | Soulshatter | Racial / Other | 180 | 1 |
| 20594 | Stoneform | Racial / Other | 120 | 1 |
| 20549 | War Stomp | Racial / Other | 120 | 1 |
| 7744 | Will of the Forsaken | Racial / Other | 120 | 1 |
| 44425 | Arcane Barrage | Mage | 3 | 3 |
| 12042 | Arcane Power | Mage | 120 | 1 |
| 11113 | Blast Wave | Mage | 30 | 9 |
| 1953 | Blink | Mage | 15 | 1 |
| 11958 | Cold Snap | Mage | 480 | 1 |
| 11129 | Combustion | Mage | 120 | 1 |
| 120 | Cone of Cold | Mage | 10 | 8 |
| 2139 | Counterspell | Mage | 24 | 1 |
| 44572 | Deep Freeze | Mage | 30 | 1 |
| 31661 | Dragon's Breath | Mage | 20 | 6 |
| 12051 | Evocation | Mage | 240 | 1 |
| 2136 | Fire Blast | Mage | 8 | 11 |
| 543 | Fire Ward | Mage | 30 | 7 |
| 122 | Frost Nova | Mage | 25 | 6 |
| 6143 | Frost Ward | Mage | 30 | 7 |
| 59548 | Gift of the Naaru | Mage | 180 | 1 |
| 11426 | Ice Barrier | Mage | 30 | 8 |
| 45438 | Ice Block | Mage | 300 | 1 |
| 12472 | Icy Veins | Mage | 180 | 1 |
| 66 | Invisibility | Mage | 180 | 1 |
| 55342 | Mirror Image | Mage | 180 | 1 |
| 53142 | Portal: Dalaran | Mage | 60 | 1 |
| 11419 | Portal: Darnassus | Mage | 60 | 1 |
| 32266 | Portal: Exodar | Mage | 60 | 1 |
| 11416 | Portal: Ironforge | Mage | 60 | 1 |
| 11417 | Portal: Orgrimmar | Mage | 60 | 1 |
| 33691 | Portal: Shattrath | Mage | 60 | 2 |
| 32267 | Portal: Silvermoon | Mage | 60 | 1 |
| 49361 | Portal: Stonard | Mage | 60 | 1 |
| 10059 | Portal: Stormwind | Mage | 60 | 1 |
| 49360 | Portal: Theramore | Mage | 60 | 1 |
| 11420 | Portal: Thunder Bluff | Mage | 60 | 1 |
| 11418 | Portal: Undercity | Mage | 60 | 1 |
| 12043 | Presence of Mind | Mage | 120 | 1 |
| 43987 | Ritual of Refreshment | Mage | 300 | 2 |
| 31687 | Summon Water Elemental | Mage | 180 | 1 |
| 70909 | Summon Water Elemental (Prototype) | Mage | 180 | 1 |
| 18499 | Berserker Rage | Warrior | 30 | 1 |
| 46924 | Bladestorm | Warrior | 90 | 1 |
| 2687 | Bloodrage | Warrior | 60 | 1 |
| 23881 | Bloodthirst | Warrior | 4 | 1 |
| 1161 | Challenging Shout | Warrior | 180 | 1 |
| 100 | Charge | Warrior | 15 | 3 |
| 12809 | Concussion Blow | Warrior | 30 | 1 |
| 12292 | Death Wish | Warrior | 180 | 1 |
| 676 | Disarm | Warrior | 60 | 1 |
| 55694 | Enraged Regeneration | Warrior | 180 | 1 |
| 28880 | Gift of the Naaru | Warrior | 180 | 1 |
| 57755 | Heroic Throw | Warrior | 60 | 1 |
| 20252 | Intercept | Warrior | 30 | 1 |
| 3411 | Intervene | Warrior | 30 | 1 |
| 5246 | Intimidating Shout | Warrior | 120 | 1 |
| 12975 | Last Stand | Warrior | 180 | 1 |
| 694 | Mocking Blow | Warrior | 60 | 1 |
| 12294 | Mortal Strike | Warrior | 6 | 8 |
| 7384 | Overpower | Warrior | 5 | 1 |
| 6552 | Pummel | Warrior | 10 | 1 |
| 1719 | Recklessness | Warrior | 300 | 1 |
| 20230 | Retaliation | Warrior | 300 | 1 |
| 6572 | Revenge | Warrior | 5 | 9 |
| 64382 | Shattering Throw | Warrior | 300 | 1 |
| 72 | Shield Bash | Warrior | 12 | 1 |
| 2565 | Shield Block | Warrior | 60 | 1 |
| 23922 | Shield Slam | Warrior | 6 | 8 |
| 871 | Shield Wall | Warrior | 300 | 1 |
| 46968 | Shockwave | Warrior | 20 | 1 |
| 23920 | Spell Reflection | Warrior | 10 | 1 |
| 12328 | Sweeping Strikes | Warrior | 30 | 1 |
| 355 | Taunt | Warrior | 8 | 1 |
| 6343 | Thunder Clap | Warrior | 6 | 9 |
| 1680 | Whirlwind | Warrior | 10 | 1 |
| 59671 | Challenging Howl | Warlock | 15 | 1 |
| 50796 | Chaos Bolt | Warlock | 12 | 4 |
| 17962 | Conflagrate | Warlock | 10 | 1 |
| 603 | Curse of Doom | Warlock | 60 | 3 |
| 6789 | Death Coil | Warlock | 120 | 6 |
| 48020 | Demonic Circle: Teleport | Warlock | 30 | 1 |
| 47193 | Demonic Empowerment | Warlock | 60 | 1 |
| 18708 | Fel Domination | Warlock | 180 | 1 |
| 48181 | Haunt | Warlock | 8 | 4 |
| 5484 | Howl of Terror | Warlock | 40 | 2 |
| 50589 | Immolation Aura | Warlock | 30 | 1 |
| 47241 | Metamorphosis | Warlock | 180 | 4 |
| 18540 | Ritual of Doom | Warlock | 1800 | 1 |
| 29893 | Ritual of Souls | Warlock | 300 | 2 |
| 698 | Ritual of Summoning | Warlock | 120 | 1 |
| 50581 | Shadow Cleave | Warlock | 6 | 1 |
| 6229 | Shadow Ward | Warlock | 30 | 6 |
| 17877 | Shadowburn | Warlock | 15 | 10 |
| 47897 | Shadowflame | Warlock | 15 | 2 |
| 30283 | Shadowfury | Warlock | 20 | 5 |
| 34861 | Circle of Healing | Priest | 6 | 7 |
| 19236 | Desperate Prayer | Priest | 120 | 9 |
| 47585 | Dispersion | Priest | 120 | 1 |
| 64843 | Divine Hymn | Priest | 480 | 1 |
| 586 | Fade | Priest | 30 | 1 |
| 6346 | Fear Ward | Priest | 180 | 1 |
| 59544 | Gift of the Naaru | Priest | 180 | 1 |
| 47788 | Guardian Spirit | Priest | 180 | 1 |
| 14914 | Holy Fire | Priest | 10 | 11 |
| 64901 | Hymn of Hope | Priest | 360 | 1 |
| 14751 | Inner Focus | Priest | 180 | 1 |
| 724 | Lightwell | Priest | 180 | 6 |
| 8092 | Mind Blast | Priest | 8 | 13 |
| 33206 | Pain Suppression | Priest | 180 | 1 |
| 47540 | Penance | Priest | 12 | 4 |
| 10060 | Power Infusion | Priest | 120 | 1 |
| 17 | Power Word: Shield | Priest | 4 | 14 |
| 33076 | Prayer of Mending | Priest | 10 | 3 |
| 64044 | Psychic Horror | Priest | 120 | 1 |
| 8122 | Psychic Scream | Priest | 30 | 4 |
| 32379 | Shadow Word: Death | Priest | 12 | 4 |
| 34433 | Shadowfiend | Priest | 300 | 1 |
| 15487 | Silence | Priest | 45 | 1 |
| 22812 | Barkskin | Druid | 60 | 1 |
| 5211 | Bash | Druid | 60 | 3 |
| 50334 | Berserk | Druid | 180 | 1 |
| 5209 | Challenging Roar | Druid | 180 | 1 |
| 8998 | Cower | Druid | 10 | 6 |
| 1850 | Dash | Druid | 180 | 3 |
| 5229 | Enrage | Druid | 60 | 1 |
| 16857 | Faerie Fire (Feral) | Druid | 6 | 1 |
| 16979 | Feral Charge - Bear | Druid | 15 | 1 |
| 49376 | Feral Charge - Cat | Druid | 30 | 1 |
| 33831 | Force of Nature | Druid | 180 | 1 |
| 22842 | Frenzied Regeneration | Druid | 180 | 1 |
| 6795 | Growl | Druid | 8 | 1 |
| 29166 | Innervate | Druid | 180 | 1 |
| 22570 | Maim | Druid | 10 | 2 |
| 33878 | Mangle (Bear) | Druid | 6 | 5 |
| 16689 | Nature's Grasp | Druid | 60 | 8 |
| 17116 | Nature's Swiftness | Druid | 180 | 1 |
| 5215 | Prowl | Druid | 10 | 1 |
| 20484 | Rebirth | Druid | 600 | 7 |
| 48505 | Starfall | Druid | 90 | 4 |
| 61336 | Survival Instincts | Druid | 180 | 1 |
| 18562 | Swiftmend | Druid | 15 | 1 |
| 5217 | Tiger's Fury | Druid | 30 | 6 |
| 740 | Tranquility | Druid | 480 | 7 |
| 50516 | Typhoon | Druid | 20 | 5 |
| 48438 | Wild Growth | Druid | 6 | 4 |
| 13750 | Adrenaline Rush | Rogue | 180 | 1 |
| 13877 | Blade Flurry | Rogue | 120 | 1 |
| 2094 | Blind | Rogue | 180 | 1 |
| 31224 | Cloak of Shadows | Rogue | 90 | 1 |
| 14177 | Cold Blood | Rogue | 180 | 1 |
| 51722 | Dismantle | Rogue | 60 | 1 |
| 1725 | Distract | Rogue | 30 | 1 |
| 5277 | Evasion | Rogue | 180 | 2 |
| 1966 | Feint | Rogue | 10 | 8 |
| 14278 | Ghostly Strike | Rogue | 20 | 1 |
| 1776 | Gouge | Rogue | 10 | 1 |
| 1766 | Kick | Rogue | 10 | 1 |
| 408 | Kidney Shot | Rogue | 20 | 2 |
| 51690 | Killing Spree | Rogue | 120 | 1 |
| 14183 | Premeditation | Rogue | 20 | 1 |
| 14185 | Preparation | Rogue | 480 | 1 |
| 14251 | Riposte | Rogue | 6 | 1 |
| 51713 | Shadow Dance | Rogue | 60 | 1 |
| 36554 | Shadowstep | Rogue | 30 | 1 |
| 2983 | Sprint | Rogue | 180 | 3 |
| 1784 | Stealth | Rogue | 10 | 1 |
| 57934 | Tricks of the Trade | Rogue | 30 | 1 |
| 1856 | Vanish | Rogue | 180 | 3 |
| 19434 | Aimed Shot | Hunter | 10 | 9 |
| 3044 | Arcane Shot | Hunter | 6 | 11 |
| 19574 | Bestial Wrath | Hunter | 120 | 1 |
| 3674 | Black Arrow | Hunter | 30 | 6 |
| 62757 | Call Stabled Pet | Hunter | 300 | 1 |
| 53209 | Chimera Shot | Hunter | 10 | 1 |
| 5116 | Concussive Shot | Hunter | 12 | 1 |
| 19306 | Counterattack | Hunter | 5 | 6 |
| 19263 | Deterrence | Hunter | 90 | 1 |
| 781 | Disengage | Hunter | 25 | 1 |
| 20736 | Distracting Shot | Hunter | 8 | 1 |
| 53301 | Explosive Shot | Hunter | 6 | 4 |
| 13813 | Explosive Trap | Hunter | 30 | 6 |
| 5384 | Feign Death | Hunter | 30 | 1 |
| 1543 | Flare | Hunter | 20 | 1 |
| 60192 | Freezing Arrow | Hunter | 30 | 2 |
| 1499 | Freezing Trap | Hunter | 30 | 3 |
| 13809 | Frost Trap | Hunter | 30 | 1 |
| 59543 | Gift of the Naaru | Hunter | 180 | 1 |
| 13795 | Immolation Trap | Hunter | 30 | 8 |
| 19577 | Intimidation | Hunter | 60 | 1 |
| 34026 | Kill Command | Hunter | 60 | 1 |
| 53351 | Kill Shot | Hunter | 15 | 3 |
| 56453 | Lock and Load | Hunter | 22 | 1 |
| 53271 | Master's Call | Hunter | 60 | 1 |
| 34477 | Misdirection | Hunter | 30 | 1 |
| 1495 | Mongoose Bite | Hunter | 5 | 6 |
| 2643 | Multi-Shot | Hunter | 10 | 8 |
| 3045 | Rapid Fire | Hunter | 300 | 1 |
| 2973 | Raptor Strike | Hunter | 6 | 11 |
| 23989 | Readiness | Hunter | 180 | 1 |
| 1513 | Scare Beast | Hunter | 30 | 3 |
| 19503 | Scatter Shot | Hunter | 30 | 1 |
| 34490 | Silencing Shot | Hunter | 20 | 1 |
| 34600 | Snake Trap | Hunter | 30 | 1 |
| 19801 | Tranquilizing Shot | Hunter | 8 | 1 |
| 3034 | Viper Sting | Hunter | 15 | 1 |
| 19386 | Wyvern Sting | Hunter | 60 | 6 |
| 31821 | Aura Mastery | Paladin | 120 | 1 |
| 31935 | Avenger's Shield | Paladin | 30 | 5 |
| 31884 | Avenging Wrath | Paladin | 180 | 1 |
| 20116 | Consecration | Paladin | 8 | 8 |
| 35395 | Crusader Strike | Paladin | 4 | 1 |
| 20216 | Divine Favor | Paladin | 120 | 1 |
| 31842 | Divine Illumination | Paladin | 180 | 1 |
| 19752 | Divine Intervention | Paladin | 600 | 1 |
| 54428 | Divine Plea | Paladin | 60 | 1 |
| 498 | Divine Protection | Paladin | 180 | 1 |
| 64205 | Divine Sacrifice | Paladin | 120 | 1 |
| 642 | Divine Shield | Paladin | 300 | 1 |
| 53385 | Divine Storm | Paladin | 10 | 1 |
| 879 | Exorcism | Paladin | 15 | 9 |
| 59542 | Gift of the Naaru | Paladin | 180 | 1 |
| 10308 | Hammer of Justice | Paladin | 60 | 4 |
| 24239 | Hammer of Wrath | Paladin | 6 | 6 |
| 53595 | Hammer of the Righteous | Paladin | 6 | 1 |
| 1044 | Hand of Freedom | Paladin | 25 | 1 |
| 1022 | Hand of Protection | Paladin | 300 | 3 |
| 62124 | Hand of Reckoning | Paladin | 8 | 1 |
| 6940 | Hand of Sacrifice | Paladin | 120 | 1 |
| 1038 | Hand of Salvation | Paladin | 120 | 1 |
| 20925 | Holy Shield | Paladin | 8 | 6 |
| 20473 | Holy Shock | Paladin | 6 | 7 |
| 2812 | Holy Wrath | Paladin | 30 | 5 |
| 53407 | Judgement of Justice | Paladin | 10 | 1 |
| 20271 | Judgement of Light | Paladin | 10 | 1 |
| 53408 | Judgement of Wisdom | Paladin | 10 | 1 |
| 633 | Lay on Hands | Paladin | 1200 | 5 |
| 20066 | Repentance | Paladin | 60 | 1 |
| 31789 | Righteous Defense | Paladin | 8 | 1 |
| 53600 | Shield of Righteousness | Paladin | 6 | 2 |
| 556 | Astral Recall | Shaman | 900 | 1 |
| 2825 | Bloodlust | Shaman | 300 | 1 |
| 421 | Chain Lightning | Shaman | 6 | 8 |
| 2062 | Earth Elemental Totem | Shaman | 600 | 1 |
| 8042 | Earth Shock | Shaman | 6 | 10 |
| 2484 | Earthbind Totem | Shaman | 15 | 1 |
| 16166 | Elemental Mastery | Shaman | 180 | 1 |
| 51533 | Feral Spirit | Shaman | 180 | 1 |
| 2894 | Fire Elemental Totem | Shaman | 600 | 1 |
| 1535 | Fire Nova | Shaman | 10 | 9 |
| 8050 | Flame Shock | Shaman | 6 | 9 |
| 8056 | Frost Shock | Shaman | 6 | 7 |
| 59547 | Gift of the Naaru | Shaman | 180 | 1 |
| 8177 | Grounding Totem | Shaman | 15 | 1 |
| 32182 | Heroism | Shaman | 300 | 1 |
| 51514 | Hex | Shaman | 45 | 1 |
| 51505 | Lava Burst | Shaman | 8 | 2 |
| 60103 | Lava Lash | Shaman | 6 | 1 |
| 16190 | Mana Tide Totem | Shaman | 300 | 1 |
| 16188 | Nature's Swiftness | Shaman | 120 | 1 |
| 21169 | Reincarnation | Shaman | 1800 | 1 |
| 61295 | Riptide | Shaman | 6 | 4 |
| 30823 | Shamanistic Rage | Shaman | 60 | 1 |
| 5730 | Stoneclaw Totem | Shaman | 30 | 10 |
| 17364 | Stormstrike | Shaman | 8 | 1 |
| 51490 | Thunderstorm | Shaman | 45 | 4 |
| 55198 | Tidal Force | Shaman | 180 | 1 |
| 57994 | Wind Shear | Shaman | 6 | 1 |
| 48707 | Anti-Magic Shell | Death Knight | 45 | 1 |
| 51052 | Anti-Magic Zone | Death Knight | 120 | 1 |
| 42650 | Army of the Dead | Death Knight | 600 | 1 |
| 45529 | Blood Tap | Death Knight | 60 | 1 |
| 49222 | Bone Shield | Death Knight | 60 | 1 |
| 49158 | Corpse Explosion | Death Knight | 5 | 5 |
| 49028 | Dancing Rune Weapon | Death Knight | 90 | 1 |
| 56222 | Dark Command | Death Knight | 8 | 1 |
| 49576 | Death Grip | Death Knight | 35 | 1 |
| 48743 | Death Pact | Death Knight | 120 | 1 |
| 43265 | Death and Decay | Death Knight | 30 | 4 |
| 49796 | Deathchill | Death Knight | 120 | 1 |
| 47568 | Empower Rune Weapon | Death Knight | 300 | 1 |
| 57532 | Eye of Acherus | Death Knight | 10 | 1 |
| 63560 | Ghoul Frenzy | Death Knight | 10 | 1 |
| 59545 | Gift of the Naaru | Death Knight | 180 | 1 |
| 57330 | Horn of Winter | Death Knight | 20 | 2 |
| 49184 | Howling Blast | Death Knight | 8 | 4 |
| 49203 | Hungering Cold | Death Knight | 60 | 1 |
| 49016 | Hysteria | Death Knight | 180 | 1 |
| 48792 | Icebound Fortitude | Death Knight | 120 | 1 |
| 52372 | Icy Touch | Death Knight | 6 | 1 |
| 49039 | Lichborne | Death Knight | 120 | 1 |
| 49005 | Mark of Blood | Death Knight | 180 | 1 |
| 47528 | Mind Freeze | Death Knight | 10 | 1 |
| 61999 | Raise Ally | Death Knight | 600 | 1 |
| 46584 | Raise Dead | Death Knight | 180 | 1 |
| 48982 | Rune Tap | Death Knight | 60 | 1 |
| 47476 | Strangulate | Death Knight | 120 | 1 |
| 49206 | Summon Gargoyle | Death Knight | 180 | 1 |
| 51271 | Unbreakable Armor | Death Knight | 60 | 1 |
| 55233 | Vampiric Blood | Death Knight | 60 | 1 |
