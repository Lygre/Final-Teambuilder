import Cocoa


var monImport = """
Kommo-o @ Leftovers
Ability: Bulletproof
EVs: 252 Atk / 252 Spe
Naive Nature
- Poison Jab
- Outrage
- Close Combat
- Dragon Dance

Mandibuzz @ Leftovers
Ability: Overcoat
EVs: 248 HP / 216 Def / 28 SpD / 16 Spe
Impish Nature
- Defog
- Roost
- Foul Play
- Whirlwind

Kartana @ Steelium Z
Ability: Beast Boost
EVs: 204 HP / 52 Def / 252 Spe
Timid Nature
IVs: 19 Atk
- Leaf Blade
- Smart Strike
- Swords Dance
- Sacred Sword

Blacephalon @ Choice Scarf
Ability: Beast Boost
EVs: 252 SpA / 252 Spe
Modest Nature
- Shadow Ball
- Flamethrower
- Fire Blast
- Mind Blown

Mawile-Mega @ Mawilite
Ability: Huge Power
EVs: 138 HP / 252 Atk / 120 Spe
Adamant Nature
- Play Rough
- Sucker Punch
- Thunder Punch
- Ice Punch

Seismitoad @ Leftovers
Ability: Water Absorb
EVs: 223 HP / 36 Atk / 64 Def / 185 SpD
Careful Nature
- Earthquake
- Stealth Rock
- Toxic
- Protect
"""

var monStringArray = [String]()

//var monImportString = String()
monStringArray = monImport.components(separatedBy: "\n\n")

monStringArray

for monImportString in monStringArray {
//	print(monImportString)
	let monImportStringArray: [String] = monImportString.components(separatedBy: "\n")
	for line in monImportStringArray {
		
	}
}
