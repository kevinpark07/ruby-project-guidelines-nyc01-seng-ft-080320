User.destroy_all
Item.destroy_all
Spell.destroy_all
Scenario.destroy_all

anson = User.create("Anson")
kevin = User.create("Kevin")

wand = Item.create("A Plain Wand", "Channels magical energies")
clock = Item.create("Invisibility Clock", "Hide from your enemies!")
sword = Item.create("Slightly Dull Sword", "Stick 'em with the pointy end.")
beer = Item.create("Butter Beer", "You never know when you need to feel joy.")
map = Item.create("Marauder's Map", "Helpful Guide to Hogwarts.")
whizbang = Item.create("Whiz-Bangs", "Selection of distracting fireworks.")


accio = Spell.create("Accio", "Summon items to your hand.")
protego = Spell.create("Protego", "Creates a limited protective shield around you.")
incendio = Spell.create("Incendio", "Fire can hurt. It can also help."
stupedy = Spell.create("Stupefy", "Stun an object or being.")