User.destroy_all
Item.destroy_all
Spell.destroy_all
Scenario.destroy_all
Game.destroy_all

anson = User.create(name: "Anson")
kevin = User.create(name: "Kevin")

wand = Item.create(name: "A Plain Wand", description: "Channels magical energies")
clock = Item.create(name: "Invisibility Cloak", description: "Hide from your enemies!")
sword = Item.create(name: "Slightly Dull Sword", description: "Stick 'em with the pointy end.")
beer = Item.create(name: "Butter Beer", description: "You never know when you need to feel joy.")
map = Item.create(name: "Marauder's Map", description: "Helpful Guide to Hogwarts.")
whizbang = Item.create(name: "Whiz-Bangs", description: "Selection of distracting fireworks.")


accio = Spell.create(name: "Accio", description: "Summon items to your hand.")
protego = Spell.create(name: "Protego", description: "Creates a limited protective shield around you.")
incendio = Spell.create(name: "Incendio", description: "Fire can hurt. It can also help.")
stupefy = Spell.create(name: "Stupefy", description: "Stun an object or being.")